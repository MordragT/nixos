{
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  hwloc,
  lib,
}:
let
  major = "2022.3";
  version = "2022.3.0-381";

  pins = builtins.fromJSON (builtins.readFile ./default.lock);
  srcs = lib.mapAttrsToList (_: fetchurl) pins;
in
stdenvNoCC.mkDerivation {
  inherit version srcs;
  pname = "intel-tbb";

  # dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    hwloc
  ];

  autoPatchelfIgnoreMissingDeps = [ "libhwloc.so.5" ];

  unpackPhase = ''
    for src in $srcs; do
      dpkg-deb -x "$src" .
    done
  '';

  installPhase = ''
    mkdir -p $out

    cd ./opt/intel/oneapi/tbb/${major}

    mv env $out/env
    mv etc $out/etc
    mv include $out/include
    mv lib $out/lib
    mv share $out/share
  '';
}
