{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  gnutar,
  stdenv,
  level-zero,
  zlib,
  libxml2,
  ocl-icd,
}:
stdenvNoCC.mkDerivation rec {
  pname = "intel-llvm-bin";
  version = "nightly-2024-08-19";

  src = fetchurl {
    url = "https://github.com/intel/llvm/releases/download/${version}/sycl_linux.tar.gz";
    hash = "sha256-67Is+dwP9n7zci+rx0aQE9F2Bt5vE/4vsJUWZqdLTgo=";
  };

  outputs = ["out" "dev" "lib"];

  nativeBuildInputs = [
    autoPatchelfHook
    gnutar
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    level-zero
    zlib
    libxml2
    ocl-icd
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libamd_comgr.so.2"
    "libamdhip64.so.6"
    "libcuda.so.1"
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    tar xf $src --directory=.

    mv lib/clang/19 clang

    mkdir $out
    mv bin $out/bin
    mkdir $out/share
    mv clang/share $out/share/clang

    mkdir $dev
    mv include $dev/include
    mv clang/include $dev/include/clang
    mkdir -p $dev/lib/cmake/IntelSYCL
    cp ${./IntelSYCLConfig.cmake} $dev/lib/cmake/IntelSYCL/IntelSYCLConfig.cmake

    mkdir $lib
    mv lib $lib/lib
    mv clang/lib $lib/lib/clang
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
