{
  stdenv,
  llvm,
  mkLLVM,
}:
mkLLVM {
  inherit stdenv;

  name = "clang";
  extraBuildInputs = [
    llvm
  ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_TARGETS_TO_BUILD=X86"
    # tests
    "-DLLVM_INCLUDE_TESTS=OFF"
    # "-DLLVM_BUILD_TESTS=OFF"
    "-DLLVM_ENABLE_ASSERTIONS=OFF"
    # docs
    # "-DLLVM_ENABLE_DOXYGEN=OFF"
    # "-DLLVM_ENABLE_SPHINX=OFF"

    "-DLLVM_INSTALL_UTILS=ON"

    # "-DLLVM_INCLUDE_DIRS=${llvm}/include:../llvm/include/llvm/SYCLLowerIR"

    # no idea why device_config is not found
    # "-DLLVM_TABLEGEN_FLAGS=-I/llvm/include/llvm/SYCLLowerIR/"
  ];
  passthru.isClang = true;
}
