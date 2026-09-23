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
  ...
}:
let
  # Intel XPU runtime wheel pins (declared as Requires-Dist by torch-2.10.0+xpu).
  # These are PyPI-hosted wheels from Intel.
  # All are py2.py3-none-manylinux_2_28_x86_64 binary
  # distributions containing .so files and Python shims.
  wheels = builtins.fromJSON (builtins.readFile ./wheels.lock);
in
stdenv.mkDerivation {
  pname = "intel-oneapi";
  version = "2025.3";

  srcs = lib.mapAttrsToList (_: whl: fetchurl { inherit (whl) url hash; }) wheels;

  sourceRoot = ".";

  dontConfigure = true;
  dontBuild = true;
  # Runtime library stuff — no binaries, no Python, just .so files.
  dontStrip = true;

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
  ];

  # Ignore-list for deps neither the wheels nor nixpkgs provide.
  # Intel wheel-to-wheel SONAME refs are resolved
  autoPatchelfIgnoreMissingDeps = [
    # impi-rt fabric plugins (RDMA / InfiniBand / PSM / EFA / UCX) — loaded
    # only when MPI distributed mode is requested.
    "librdmacm.so.1"
    "libibverbs.so.1"
    "libucp.so.0"
    "libnuma.so.1"
    "libpsm2.so.2"
    "libefa.so.1"
  ];

  unpackPhase = ''
    runHook preUnpack
    for whl in $srcs; do
      mkdir -p "wheel_$(basename "$whl" .whl)"
      unzip -q "$whl" -d "wheel_$(basename "$whl" .whl)"
    done
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/share/intel-oneapi
    # Collect .so files from each wheel's .data/data/lib into $out/lib.
    # Later wheels' files overwrite earlier only on exact filename match;
    # Intel wheels use distinct filenames so this is safe.
    for wheel_dir in wheel_*; do
      if [ -d "$wheel_dir" ]; then
        for data_lib in "$wheel_dir"/*.data/data/lib; do
          if [ -d "$data_lib" ]; then
            cp -rn "$data_lib"/. $out/lib/ 2>/dev/null || \
              cp -r "$data_lib"/. $out/lib/
          fi
        done
        # Also copy any top-level lib dirs (some wheels use that layout)
        if [ -d "$wheel_dir/lib" ]; then
          cp -rn "$wheel_dir/lib"/. $out/lib/ 2>/dev/null || true
        fi
        # Preserve license / manifest files under share/ for compliance
        for meta in "$wheel_dir"/*.dist-info/METADATA; do
          if [ -f "$meta" ]; then
            pname=$(basename "$(dirname "$meta")" .dist-info)
            mkdir -p "$out/share/intel-oneapi/$pname"
            cp "$meta" "$out/share/intel-oneapi/$pname/"
          fi
        done
      fi
    done
    runHook postInstall
  '';

  meta = {
    description = "Combined Intel oneAPI runtime libraries (from PyPI wheels)";
    homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit.html";
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}
