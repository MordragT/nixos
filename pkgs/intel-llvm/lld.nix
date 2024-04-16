{
  stdenv,
  llvm,
  mkLLVM,
}:
mkLLVM {
  inherit stdenv;

  name = "lld";

  extraBuildInputs = [
    llvm
  ];

  # cmakeFlags = [
  #   "-DCMAKE_BUILD_TYPE=Release"
  #   "-DLLVM_TARGETS_TO_BUILD=Native"
  #   "-DLLVM_INCLUDE_TESTS=OFF"
  # ];
}
