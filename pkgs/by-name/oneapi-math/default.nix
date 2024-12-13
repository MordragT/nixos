{
  lib,
  intel-dpcpp,
  fetchFromGitHub,
  cmake,
  level-zero,
  oneapi-tbb,
  intel-mkl,
  blas,
  lapack,
  ocl-icd,
}:
# requires dpcpp compiler
intel-dpcpp.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-math";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneMath";
    rev = "v${finalAttrs.version}";
    hash = "sha256-f9eXjL2qLpIfNxU3pFUMWE3ztZE2S0uv1PHLQfvyiSk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DMKL_ROOT=${intel-mkl}"
    "-DBUILD_FUNCTIONAL_TESTS=OFF"
  ];

  buildInputs = [
    intel-dpcpp.llvm.lib
    intel-mkl
    level-zero
    oneapi-tbb
    blas.dev
    lapack.dev
    ocl-icd
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    changelog = "https://github.com/uxlfoundation/oneMath/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Math Library (oneMath)";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
