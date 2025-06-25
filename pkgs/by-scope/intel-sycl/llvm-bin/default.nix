{
  stdenvNoCC,
  version,
  fetchzip,
  fetchurl,
  autoPatchelfHook,
  stdenv,
  level-zero,
  zlib,
  libxml2,
  ocl-icd,
  hwloc,
  lib,
}: let
  # Abi breaking change in libxml2 therefore not compatible with latest libxml2 2.14.3
  libxml2' = libxml2.overrideAttrs rec {
    version = "2.13.8";
    src = fetchurl {
      url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
      hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
    };
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;

    pname = "intel-llvm-bin";

    src = fetchzip {
      url = "https://github.com/intel/llvm/releases/download/v${version}/linux-sycl-${version}.tar.gz";
      hash = "sha256-hpo64WB/D5Lzt2q6mnSjH5ax0S2LPJJhsgVO4Cl+z5E=";
      stripRoot = false;
    };

    outputs = ["out" "dev" "lib" "rsrc"];

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      stdenv.cc.cc.lib
      level-zero
      zlib
      libxml2'
      ocl-icd
      hwloc
    ];

    autoPatchelfIgnoreMissingDeps = [
      "libamd_comgr.so.2"
      "libamdhip64.so.6"
      "libcuda.so.1"
      "libnvidia-ml.so.1"
    ];

    dontBuild = true;
    dontFixup = true;
    dontAutoPatchelf = true;

    installPhase = ''
      mkdir $rsrc
      mv lib/clang/20/include $rsrc/include
      rm -r lib/clang

      mkdir $out
      mv bin $out/bin

      mkdir $dev
      mv include $dev/include

      mkdir $lib
      mv lib $lib/lib

      autoPatchelf $out $lib
    '';

    passthru.isLLVM = true;
    passthru.isClang = true;

    meta = {
      description = "Intel staging area for llvm.org contribution. Home for Intel LLVM-based projects.";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [mordrag];
      platforms = lib.platforms.all;
    };
  }
