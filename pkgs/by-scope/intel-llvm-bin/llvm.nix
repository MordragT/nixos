{
  lib,
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  stdenv,
  level-zero,
  zlib,
  libxml2,
  ocl-icd,
}:
stdenvNoCC.mkDerivation rec {
  pname = "intel-llvm-bin";
  version = "nightly-2024-12-12";

  src = fetchzip {
    url = "https://github.com/intel/llvm/releases/download/${version}/sycl_linux.tar.gz";
    hash = "sha256-d321blBeYKJtcAbPbIT7IEybe4473kAwRp1nWbSJPZ0=";
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
    libxml2
    ocl-icd
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libamd_comgr.so.2"
    "libamdhip64.so.6"
    "libcuda.so.1"
  ];

  dontBuild = true;

  installPhase = ''
    mv lib/clang/20 $rsrc

    mkdir $out
    mv bin $out/bin

    mkdir $dev
    mv include $dev/include
    mkdir -p $dev/lib/cmake/IntelSYCL
    cp ${./IntelSYCLConfig.cmake} $dev/lib/cmake/IntelSYCL/IntelSYCLConfig.cmake

    mkdir $lib
    mv lib $lib/lib
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
