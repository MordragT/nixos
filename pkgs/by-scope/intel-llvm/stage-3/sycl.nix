{
  mkLLVM,
  stdenv,
  level-zero,
  opencl-headers,
  ocl-icd,
  boost,
  pins,
}: let
  unified-runtime = stdenv.mkDerivation {
    name = "unified-runtime-src";
    src = pins.unified-runtime;

    patches = [
      ./umf.patch
    ];

    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };
in
  mkLLVM {
    inherit stdenv;
    name = "sycl";
    targetDir = "llvm";

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_TARGETS_TO_BUILD=Native"
      "-DLLVM_INSTALL_UTILS=ON"

      # sycl tests
      "-DSYCL_INCLUDE_TESTS=OFF"
      "-DSYCL_PI_TESTS=OFF"

      # tests
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DLLVM_BUILD_TESTS=OFF"
      "-DLLVM_ENABLE_ASSERTIONS=OFF"

      # docs
      "-DLLVM_ENABLE_DOXYGEN=OFF"
      "-DLLVM_ENABLE_SPHINX=OFF"

      # plugins
      "-DSYCL_BUILD_PI_HIP_PLATFORM=''"
      "-DSYCL_BUILD_PI_ESIMD_CPU=OFF"

      # options
      "-DSYCL_ENABLE_WERROR=OFF"
      "-DSYCL_ENABLE_XPTI_TRACING=ON"
      "-DSYCL_ENABLE_PLUGINS=opencl;level_zero;"
      "-DSYCL_ENABLE_KERNEL_FUSION=ON"
      "-DSYCL_ENABLE_MAJOR_RELEASE_PREVIEW_LIB=ON"

      # projects
      "-DLLVM_EXTERNAL_PROJECTS=sycl;sycl-fusion;llvm-spirv;opencl;xpti;xptifw;libdevice"
      "-DLLVM_EXTERNAL_SYCL_SOURCE_DIR=/build/source/sycl"
      "-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=/build/source/llvm-spirv"
      "-DLLVM_EXTERNAL_XPTI_SOURCE_DIR=/build/source/xpti"
      "-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR=/build/source/xptifw"
      "-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR=/build/source/libdevice"
      "-DLLVM_EXTERNAL_SYCL_FUSION_SOURCE_DIR=/build/source/sycl-fusion"
      "-DLLVM_ENABLE_PROJECTS=clang;sycl;sycl-fusion;llvm-spirv;opencl;xpti;xptifw;libdevice"

      # sources
      "-DLLVMGenXIntrinsics_SOURCE_DIR=${pins.vc-intrinsics}"
      "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${pins.spirv-headers}"
      "-DSYCL_PI_UR_USE_FETCH_CONTENT=OFF"
      "-DSYCL_PI_UR_SOURCE_DIR=${unified-runtime}"
      "-DUMF_SOURCE_DIR=${pins.unified-memory-framework}"
      "-DLEVEL_ZERO_INCLUDE_DIR=${level-zero}/include/level_zero"
      "-DLEVEL_ZERO_LIBRARY=${level-zero}/lib/libze_loader.so"
      "-DOpenCL_HEADERS=${pins.ocl-headers}"
      "-DOpenCL_LIBRARY_SRC=${pins.ocl-loader}"
      "-DUR_OPENCL_INCLUDE_DIR=${opencl-headers}/include/CL"
      "-DOpenCL-ICD=${ocl-icd}/lib/libOpenCL.so"
      "-DBOOST_MP11_SOURCE_DIR=${pins.mp11}"
      "-DBOOST_MODULE_SRC_DIR=${boost.dev}"
    ];

    # https://github.com/intel/llvm/issues/6937
    buildPhase = ''
      cmake --build /build/source/llvm/build --parallel $NIX_BUILD_CORES --target=deploy-sycl-toolchain
    '';

    passthru.isLLVM = true;
    passthru.isClang = true;
  }
