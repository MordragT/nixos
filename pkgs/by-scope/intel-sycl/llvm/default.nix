{
  llvmPackages_20,
  src,
  version,
  cmake,
  pkg-config,
  python3,
  perl,
  libz,
  libxml2,
  ncurses,
  hwloc,
  level-zero,
  unified-memory-framework,
  opencl-headers,
  ocl-icd,
  boost,
  pins,
}: let
  llvmPackages = llvmPackages_20;
in
  llvmPackages.libcxxStdenv.mkDerivation {
    inherit src version;
    pname = "intel-llvm";

    # sourceRoot = "${src.name}/llvm";

    NIX_CFLAGS_COMPILE = [
      "-I${llvmPackages.libcxx.dev}/include/c++/v1"
      "-L${llvmPackages.libcxx}/lib"
      # "-Wno-unused-command-line-argument"
    ];

    patches = [
      ./compute-runtime.patch
      ./umf.patch
      ./xptifw.patch
    ];

    outputs = ["out" "lib" "dev" "rsrc"];

    nativeBuildInputs = [
      cmake
      pkg-config
      python3
      perl
    ];

    buildInputs = [
      llvmPackages.libcxx # libcxx
      llvmPackages.libcxx.dev # libcxx
      # stdenv.cc.cc # libgcc .lib libstdc++
      libz
      libxml2
      ncurses
      hwloc
      unified-memory-framework
    ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_TARGETS_TO_BUILD=Native"
      "-DLLVM_INSTALL_UTILS=ON"
      "-DLLVM_ENABLE_ZSTD=ON"
      "-DLLVM_USE_STATIC_ZSTD=ON"

      # libcxx
      "-DLLVM_ENABLE_LIBCXX=ON"
      "-DSYCL_USE_LIBCXX=ON"
      "-DSYCL_LIBCXX_INCLUDE_PATH=${llvmPackages.libcxx.dev}/include/c++/v1"
      "-DSYCL_LIBCXX_LIBRARY_PATH=${llvmPackages.libcxx}/lib"

      # tests
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DLLVM_BUILD_TESTS=OFF"
      "-DLLVM_ENABLE_ASSERTIONS=OFF"

      # docs
      "-DLLVM_ENABLE_DOXYGEN=OFF"
      "-DLLVM_ENABLE_SPHINX=OFF"

      # sycl tests
      "-DSYCL_INCLUDE_TESTS=OFF"
      "-DSYCL_PI_TESTS=OFF"

      # plugins
      "-DSYCL_BUILD_PI_HIP_PLATFORM=''"
      "-DSYCL_BUILD_PI_ESIMD_CPU=OFF"

      # options
      "-DSYCL_ENABLE_WERROR=OFF"
      "-DSYCL_ENABLE_XPTI_TRACING=ON"
      "-DSYCL_ENABLE_BACKENDS=opencl;level_zero;"
      "-DSYCL_ENABLE_KERNEL_FUSION=ON"
      "-DSYCL_ENABLE_MAJOR_RELEASE_PREVIEW_LIB=ON"

      # projects
      "-DLLVM_EXTERNAL_PROJECTS=sycl;sycl-jit;llvm-spirv;opencl;xpti;xptifw;libdevice"
      "-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=/build/source/llvm-spirv"
      "-DLLVM_EXTERNAL_XPTI_SOURCE_DIR=/build/source/xpti"
      "-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR=/build/source/xptifw"
      "-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR=/build/source/libdevice"
      "-DLLVM_EXTERNAL_SYCL_SOURCE_DIR=/build/source/sycl"
      "-DLLVM_EXTERNAL_SYCL_JIT_SOURCE_DIR=/build/source/sycl-jit"
      "-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;lld;sycl;sycl-jit;llvm-spirv;opencl;xpti;xptifw;libdevice;openmp"
      # "-DLLVM_ENABLE_RUNTIMES=libc;libunwind;libcxxabi;pstl;libcxx;compiler-rt;openmp;llvm-libgcc;offload"

      # sources
      "-DLLVMGenXIntrinsics_SOURCE_DIR=${pins.vc-intrinsics}"
      "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${pins.spirv-headers}"

      # intree is used
      # "-DSYCL_UR_USE_FETCH_CONTENT=OFF"
      # "-DSYCL_UR_SOURCE_DIR=${pins.unified-runtime}"

      "-DUR_USE_EXTERNAL_UMF=ON"
      "-DUR_OPENCL_INCLUDE_DIR=${opencl-headers}/include/CL"
      "-DUR_LEVEL_ZERO_LOADER_LIBRARY=${level-zero}/lib/libze_loader.so"
      "-DUR_LEVEL_ZERO_INCLUDE_DIR=${level-zero}/include"
      "-DUR_COMPUTE_RUNTIME_LEVEL_ZERO_INCLUDE_DIR=${pins.compute-runtime}"

      "-DLEVEL_ZERO_INCLUDE_DIR=${level-zero}/include/level_zero"
      "-DLEVEL_ZERO_LIBRARY=${level-zero}/lib/libze_loader.so"

      "-DOpenCL_HEADERS=${pins.ocl-headers}"
      "-DOpenCL_LIBRARY_SRC=${pins.ocl-loader}"
      "-DOpenCL-ICD=${ocl-icd}/lib/libOpenCL.so"

      "-DBOOST_MP11_SOURCE_DIR=${pins.mp11}"
      "-DBOOST_MODULE_SRC_DIR=${boost.dev}"

      "-DXPTIFW_EMHASH_HEADERS=${pins.emhash}"
      "-DXPTIFW_PARALLEL_HASHMAP_HEADERS=${pins.parallel-hashmap}"
    ];

    preConfigure = ''
      cd llvm
    '';

    # https://github.com/intel/llvm/issues/6937
    buildPhase = ''
      cmake --build /build/source/llvm/build --parallel $NIX_BUILD_CORES --target=deploy-sycl-toolchain
    '';

    postInstall = ''
      mv $out/lib/clang/20 $rsrc
      rm -r $out/lib/clang

      mkdir $lib
      mv $out/lib $lib/lib

      mkdir $dev
      mv $out/include $dev/include
    '';

    passthru.isLLVM = true;
    passthru.isClang = true;
  }
