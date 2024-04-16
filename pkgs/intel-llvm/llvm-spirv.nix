{
  mkLLVM,
  stdenv,
  pins,
  llvm,
}:
mkLLVM {
  inherit stdenv;
  name = "llvm-spirv";

  cmakeFlags = [
    "-DLLVM_INCLUDE_TESTS=OFF"
    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${pins.spirv-headers}"
  ];

  extraBuildInputs = [
    llvm
  ];
}
