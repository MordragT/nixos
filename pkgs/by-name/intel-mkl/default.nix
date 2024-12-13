{
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  intel-dpcpp,
  intel-mpi,
  ocl-icd,
  lib,
}: let
  major = "2025.0";
  version = "2025.0.1";

  pins = builtins.fromJSON (builtins.readFile ./default.lock);
  srcs = builtins.mapAttrs (_name: value: fetchurl value) pins;
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-mkl";

    dontStrip = true;
    # dontUnpack = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      intel-dpcpp.llvm.lib
      intel-mpi
      stdenv.cc.cc.lib
      ocl-icd
    ];

    unpackPhase = lib.concatMapAttrsStringSep "\n" (_name: src: "dpkg-deb -x ${src} .") srcs;

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/share

      cd ./opt/intel/oneapi/mkl/${major}

      mv bin $out/bin
      mv env $out/env
      mv etc $out/etc
      mv include $out/include
      mv lib $out/lib

      ln -s $out/lib/libmkl_rt.so $out/lib/libblas.so
      ln -s $out/lib/libmkl_rt.so $out/lib/libcblas.so
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapack.so
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke.so
      ln -s $out/lib/libmkl_rt.so $out/lib/libblas.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/libcblas.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapack.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke.so.3

      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/libblas64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/libcblas64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/liblapack64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/liblapacke64.so.3
      ln -s $out/lib/liblapack.so.3 $out/lib/libblas64.so
      ln -s $out/lib/libcblas64.so.3 $out/lib/libcblas64.so
      ln -s $out/lib/liblapack64.so.3 $out/lib/liblapack64.so
      ln -s $out/lib/liblapacke64.so.3 $out/lib/liblapacke64.so
      rm $out/lib/intel64
    '';
  }
