{
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  hwloc,
  lib,
}: let
  major = "2022.3";
  version = "2022.3.0-381";

  pins = builtins.fromJSON (builtins.readFile ./default.lock);
  srcs = builtins.mapAttrs (_name: value: fetchurl value) pins;
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-tbb";

    # dontUnpack = true;
    dontStrip = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      hwloc
    ];

    autoPatchelfIgnoreMissingDeps = ["libhwloc.so.5"];

    unpackPhase = lib.concatMapAttrsStringSep "\n" (_name: src: "dpkg-deb -x ${src} .") srcs;

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
