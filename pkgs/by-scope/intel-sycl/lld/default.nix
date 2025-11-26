{
  lib,
  stdenv,
  src,
  version,
  cmake,
  llvm,
  libz,
  libxml2,
}:
stdenv.mkDerivation {
  inherit src version;
  pname = "intel-lld";

  sourceRoot = "${src.name}/lld";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    llvm
    libz
    libxml2
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLD_INSTALL_PACKAGE_DIR" "${placeholder "dev"}/lib/cmake/lld")
    # (lib.cmakeFeature "LLVM_TABLEGEN_EXE" "${buildLlvmPackages.tblgen}/bin/llvm-tblgen")
  ];
}
