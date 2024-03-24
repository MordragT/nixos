{
  src,
  version,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  level-zero,
  libz,
  libxml2,
  ncurses,
  boost,
  pkg-config,
  ocl-icd,
  opencl-headers,
}: let
  vc-intrinsics-git = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "da892e1982b6c25b9a133f85b4ac97142d8a3def";
    hash = "sha256-d197m80vSICdv4VKnyqdy3flzbKLKmB8jroY2difA7o=";
  };
  ocl-headers-git = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "9ddb236e6eb3cf844f9e2f81677e1045f9bf838e";
    hash = "sha256-z4lNan3kr+WIVjGxFcFMSbdVMbiqmv5K842k+onEPJA=";
  };
  ocl-icd-git = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "9a3e962f16f5097d2054233ad8b6dad51b6f41b7";
    hash = "sha256-ScQ6Duj2lyUoW5z9xtRVvggD+5qCAq/Ou/Dj5Pkf4S4=";
  };
  mp11-git = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    rev = "ef7608b463298b881bc82eae4f45a4385ed74fca";
    hash = "sha256-5URdyIrJKilRmwQd9ajYgULRTCT1xXmJZbHcCl2EfbM=";
  };
  unified-runtime-git = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-runtime";
    rev = "c2d78257ba7e7bbc230333f291282d16145aaac7";
    hash = "sha256-9j9iwzrGMYT1hY1gmPusOMwylxCbXp/q5Gh+ZJhtai8=";
  };
  spirv-headers-git = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "1c6bb2743599e6eb6f37b2969acc0aef812e32e3";
    hash = "sha256-/I9dJlBE0kvFvqooKuqMETtOE72Jmva3zIGnq0o4+aE=";
  };
in
  stdenv.mkDerivation {
    inherit src version;

    pname = "llvm";

    passthru.isClang = true;
    passthru.isLLVM = true;

    nativeBuildInputs = [
      cmake
      python3
      pkg-config
    ];

    buildInputs = [
      libz
      libxml2
      ncurses
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_ENABLE_ASSERTIONS=OFF"
      "-DLLVM_TARGETS_TO_BUILD=X86"
      "-DLLVM_EXTERNAL_PROJECTS=sycl;sycl-fusion;llvm-spirv;opencl;xpti;xptifw"
      "-DLLVM_EXTERNAL_SYCL_SOURCE_DIR=/build/source/sycl"
      "-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=/build/source/llvm-spirv"
      "-DLLVM_EXTERNAL_XPTI_SOURCE_DIR=/build/source/xpti"
      "-DXPTI_SOURCE_DIR=/build/source/xpti"
      "-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR=/build/source/xptifw"
      # "-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR=/build/source/libdevice"
      "-DLLVM_EXTERNAL_SYCL_FUSION_SOURCE_DIR=/build/source/sycl-fusion"
      "-DLLVM_ENABLE_PROJECTS=clang;lld;sycl;sycl-fusion;llvm-spirv;opencl;xpti;xptifw"
      "-DLIBCLC_TARGETS_TO_BUILD=''"
      "-DLIBCLC_GENERATE_REMANGLED_VARIANTS=ON"
      "-DSYCL_BUILD_PI_HIP_PLATFORM=''"
      "-DLLVM_BUILD_TOOLS=ON"
      "-DSYCL_ENABLE_WERROR=OFF"
      "-DSYCL_INCLUDE_TESTS=ON"
      "-DLLVM_ENABLE_DOXYGEN=OFF"
      "-DLLVM_ENABLE_SPHINX=OFF"
      "-DLLVM_ENABLE_LLD=ON"
      "-DBUILD_SHARED_LIBS=ON"
      "-DSYCL_ENABLE_XPTI_TRACING=ON"
      "-DLLVM_ENABLE_LLD=OFF"
      "-DXPTI_ENABLE_WERROR=OFF"
      # "-DSYCL_USE_LIBCXX=ON"
      # "-DSYCL_LIBCXX_INCLUDE_PATH=${libcxx.dev}/include/c++/v1"
      # "-DSYCL_LIBCXX_LIBRARY_PATH=${lib.makeLibraryPath [libcxx]}"
      "-DSYCL_BUILD_PI_ESIMD_CPU=OFF"
      "-DSYCL_CLANG_EXTRA_FLAGS=''"
      "-DSYCL_ENABLE_PLUGINS=opencl;level_zero;"
      "-DSYCL_ENABLE_KERNEL_FUSION=ON"
      "-DSYCL_ENABLE_MAJOR_RELEASE_PREVIEW_LIB=ON"
      "-DLEVEL_ZERO_INCLUDE_DIR=${level-zero}/include/level_zero"
      "-DLEVEL_ZERO_LIBRARY=${level-zero}/lib/libze_loader.so"
      "-DSYCL_PI_TESTS=OFF"
      "-DSYCL_PI_UR_USE_FETCH_CONTENT=OFF"
      "-DSYCL_PI_UR_SOURCE_DIR=${unified-runtime-git}"
      "-DLLVMGenXIntrinsics_SOURCE_DIR=${vc-intrinsics-git}"
      "-DOpenCL_HEADERS=${ocl-headers-git}"
      "-DOpenCL_LIBRARY_SRC=${ocl-icd-git}"
      "-DBOOST_MP11_SOURCE_DIR=${mp11-git}"
      "-DBOOST_MODULE_SRC_DIR=${boost.dev}"
      "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers-git}"
      "-DUR_OPENCL_INCLUDE_DIR=${opencl-headers}/include/CL"
      "-DOpenCL-ICD=${ocl-icd}/lib/libOpenCL.so"
    ];

    prePatch = ''
      cd llvm
    '';

    # https://github.com/intel/llvm/issues/6937
    buildPhase = ''
      cmake --build /build/source/llvm/build --parallel $NIX_BUILD_CORES --target=deploy-sycl-toolchain
    '';
  }
