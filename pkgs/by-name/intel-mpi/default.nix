{
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  level-zero,
  libfabric,
  lib,
}:
let
  pins = builtins.fromJSON (builtins.readFile ./default.lock);
  srcs = lib.mapAttrsToList (_: fetchurl) pins;
in
stdenvNoCC.mkDerivation {
  inherit srcs;

  pname = "intel-mpi";
  version = "2021.17.0";

  # dontUnpack = true;
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    level-zero
    libfabric
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libiomp5.so"
    "libcuda.so.1"
  ];

  unpackPhase = ''
    for src in $srcs; do
      dpkg-deb -x "$src" .
    done
  '';

  installPhase = ''
    mkdir -p $out

    cd opt/intel/oneapi/redist

    mv bin $out/bin
    mv lib $out/lib
    mv share $out/share
  '';
}
