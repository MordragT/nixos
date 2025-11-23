{
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  level-zero,
  libfabric,
  lib,
}: let
  pins = builtins.fromJSON (builtins.readFile ./default.lock);
  srcs = builtins.mapAttrs (_name: value: fetchurl value) pins;
in
  stdenvNoCC.mkDerivation {
    pname = "intel-mpi";
    version = "2021.17.0";

    # dontUnpack = true;
    dontStrip = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      level-zero
      libfabric
    ];

    autoPatchelfIgnoreMissingDeps = ["libiomp5.so" "libcuda.so.1"];

    unpackPhase = lib.concatMapAttrsStringSep "\n" (_name: src: "dpkg-deb -x ${src} .") srcs;

    installPhase = ''
      mkdir -p $out

      cd opt/intel/oneapi/redist

      mv bin $out/bin
      mv lib $out/lib
      mv share $out/share
    '';
  }
