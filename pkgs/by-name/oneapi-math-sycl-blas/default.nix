{
  fetchFromGitHub,
  intel-sycl,
  cmake,
  ninja,
  lib,
}:
intel-sycl.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-math-sycl-blas";
  version = "unstable-2025-08-04";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "generic-sycl-components";
    # There are currently no tagged releases, tracking issue:
    # https://github.com/uxlfoundation/generic-sycl-components/issues/16
    rev = "99241128f64b700392e4cfdd047caada024bf7dd";
    hash = "sha256-JIyWclCJVqrllP5zYFv8T9wurCLixAetLVzQYt27pGY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  sourceRoot = "source/onemath/sycl/blas";

  cmakeFlags = [
    (lib.cmakeFeature "TUNING_TARGET" "INTEL_GPU")
  ];
})
