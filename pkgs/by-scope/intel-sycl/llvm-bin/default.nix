{
  stdenvNoCC,
  version,
  fetchzip,
  autoPatchelfHook,
  stdenv,
  level-zero,
  zlib,
  libxml2_13,
  ocl-icd,
  hwloc,
  lib,
}:
stdenvNoCC.mkDerivation {
  inherit version;

  pname = "intel-llvm-bin";

  src = fetchzip {
    # url = "https://github.com/intel/llvm/releases/download/v${version}/sycl_linux.tar.gz";
    # hash = "sha256-waxMqQbJK8/nkSSn0w5PcLwlzuUyTbDwcCsDKIZH45s=";
    url = "https://github.com/intel/llvm/releases/download/${version}/sycl_linux.tar.gz";
    hash = "";
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
    libxml2_13
    ocl-icd
    hwloc
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libamd_comgr.so.2"
    "libamdhip64.so.6"
    "libcupti.so.12"
    "libcuda.so.1"
    "libnvidia-ml.so.1"
  ];

  dontBuild = true;
  dontFixup = true;
  dontAutoPatchelf = true;

  installPhase = ''
    mkdir $rsrc
    mv lib/clang/22/include $rsrc/include
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
