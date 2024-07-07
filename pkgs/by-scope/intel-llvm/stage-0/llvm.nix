{
  stdenv,
  mkLLVM,
  pins,
}:
mkLLVM {
  inherit stdenv;

  name = "llvm";

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD=Native"
    # "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_INSTALL_UTILS=ON"
    # "-DLLVM_INSTALL_MODULEMAPS=ON"
    # "-DLLVM_INSTALL_BINUTILS_SYMLINKS=ON"
    # "-DLLVM_BUILD_STATIC=ON"
    # "-DLLVM_LINK_LLVM_DYLIB=ON"
    "-DLLVM_ENABLE_PROJECTS=llvm-spirv"

    # intrinsics
    "-DLLVMGenXIntrinsics_SOURCE_DIR=${pins.vc-intrinsics}"

    # tests
    "-DLLVM_INCLUDE_TESTS=OFF"
    "-DLLVM_BUILD_TESTS=OFF"
    "-DLLVM_ENABLE_ASSERTIONS=OFF"

    # docs
    "-DLLVM_ENABLE_DOXYGEN=OFF"
    "-DLLVM_ENABLE_SPHINX=OFF"

    # spirv
    "-DLLVM_EXTERNAL_PROJECTS=llvm-spirv"
    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${pins.spirv-headers}"
    "-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=/build/source/llvm-spirv"
  ];

  passthru.isLLVM = true;
  passthru.isClang = true;
}
