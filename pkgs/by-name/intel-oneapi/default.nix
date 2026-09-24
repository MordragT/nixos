{
  lib,
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  zlib,
  libGL,
  glib,
  level-zero,
  ocl-icd,
  python3,
  ...
}:
let
  # Intel XPU runtime wheel pins (declared as Requires-Dist by torch-2.10.0+xpu).
  # These are PyPI-hosted wheels from Intel.
  # All are py2.py3-none-manylinux_2_28_x86_64 binary
  # distributions containing .so files and Python shims.
  wheels = builtins.fromJSON (builtins.readFile ./wheels.lock);
  wheelSrcs = lib.mapAttrsToList (_: whl: fetchurl { inherit (whl) url hash; }) wheels;
in
stdenv.mkDerivation {
  pname = "intel-oneapi";
  version = "2026.1.2";

  srcs = wheelSrcs;

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    libGL
    glib
    level-zero
    ocl-icd
  ];

  # Ignore-list for deps neither the wheels nor nixpkgs provide.
  autoPatchelfIgnoreMissingDeps = [
    # impi-rt fabric plugins (RDMA / InfiniBand / PSM / EFA / UCX)
    "librdmacm.so.1"
    "libibverbs.so.1"
    "libucp.so.0"
    "libnuma.so.1"
    "libpsm2.so.2"
    "libefa.so.1"
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib" "$out/bin" "$out/include"
    mkdir -p "$out/${python3.sitePackages}"

    for whl in $srcs; do
      echo "unpacking $whl"
      tmp=$(mktemp -d)
      unzip -q "$whl" -d "$tmp"

      # PEP 427 wheel data scheme: <pkg>-<ver>.data/<scheme>/...
      shopt -s nullglob
      for datadir in "$tmp"/*.data; do
        [ -d "$datadir" ] || continue
        for scheme in "$datadir"/*; do
          [ -d "$scheme" ] || continue
          schemeName=$(basename "$scheme")
          case "$schemeName" in
            data)
              # Runtime libs, headers, bins from .data/data/{lib,include,bin}
              if [ -d "$scheme/lib" ]; then
                cp -af "$scheme/lib"/. "$out/lib/"
              fi
              if [ -d "$scheme/include" ]; then
                cp -af "$scheme/include"/. "$out/include/"
              fi
              if [ -d "$scheme/bin" ]; then
                cp -af "$scheme/bin"/. "$out/bin/"
              fi
              ;;
            scripts)
              cp -af "$scheme"/. "$out/bin/"
              ;;
            headers)
              cp -af "$scheme"/. "$out/include/"
              ;;
            *)
              # purelib/platlib or unknown → site-packages
              cp -af "$scheme"/. "$out/${python3.sitePackages}/"
              ;;
          esac
        done
        rm -rf "$datadir"
      done

      # Remaining top-level entries (python packages + .dist-info) go to site-packages
      if [ -n "$(ls -A "$tmp" 2>/dev/null)" ]; then
        cp -af "$tmp"/. "$out/${python3.sitePackages}/"
      fi
      rm -rf "$tmp"
    done

    # use ocl-icd instead of bundled OpenCL
    rm -f $out/lib/libOpenCL.so*

    runHook postInstall
  '';

  meta = {
    description = "Combined Intel oneAPI runtime libraries (from PyPI wheels)";
    homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}
