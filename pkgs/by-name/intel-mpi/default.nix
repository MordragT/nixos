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
    version = "2021.14.1";

    # dontUnpack = true;
    dontStrip = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      level-zero
      libfabric
    ];

    autoPatchelfIgnoreMissingDeps = ["libiomp5.so"];

    unpackPhase = lib.concatMapAttrsStringSep "\n" (_name: src: "dpkg-deb -x ${src} .") srcs;

    installPhase = ''
      mkdir -p $out

      cd opt/intel/oneapi/redist

      ls bin

      mv bin $out/bin
      mv etc $out/etc
      mv lib $out/lib
      mv share $out/share
    '';
  }
