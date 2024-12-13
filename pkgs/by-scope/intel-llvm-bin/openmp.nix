{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "intel-llvm";
  version = "nightly-2024-12-12";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = version;
    hash = "sha256-zgNzUXMwFl4vXFKDFQ2XXQgyiGNjX4b5dot4vk+WlgE=";
  };

  sourceRoot = "${src.name}/openmp";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];
}
