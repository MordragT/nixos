{
  lib,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  python3,
}:
llvmPackages.stdenv.mkDerivation rec {
  pname = "vc-intrinsics";
  version = "0.24.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "v${version}";
    hash = "sha256-IpScRc+sWEcD8ZH5TinMPVFq1++vIVp774TJsg8mUMY=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_DIR" "${lib.getDev llvmPackages.llvm}/lib/cmake/llvm")
    # (lib.cmakeBool "LLVM_LINK_LLVM_DYLIB" false)
  ];
}
