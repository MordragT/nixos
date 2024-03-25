{
  lib,
  intelPackages,
  fetchFromGitHub,
  cmake,
  level-zero,
  tbb,
  blas,
  lapack,
  blas-reference,
  lapack-reference,
}:
# let
#   blas' = blas.override {
#     blasProvider = intel-mkl;
#     isILP64 = true;
#   };
#   lapack' = lapack.override {
#     lapackProvider = intel-mkl;
#     isILP64 = true;
#   };
# in
# requires dpcpp compiler
intelPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-mkl";
  # version = "0.3";
  version = "develop";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneMKL";
    # rev = "v${finalAttrs.version}";
    # hash = "sha256-RQnAsjnzBZRCPbXtDDWEYHlRjY6YAP5mEwr/7CpcTYw=";
    rev = "3339418fa1318377c65815e6f85aced9efa46e9e";
    hash = "sha256-hiZV3jp3Jz35CHy/O/y3+ZFDDRcpmgxMxRROxhrbFQ8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFalgs = [
    "-DBUILD_FUNCTIONAL_TESTS=OFF"
    "-DREF_BLAS_ROOT=${blas-reference}"
    "-DREF_LAPACK_ROOT=${lapack-reference}"
    "-DMKL_ROOT=${intelPackages.mkl}"
    # "-DBUILD_SHARED_LIBS=OFF"
  ];

  buildInputs = [
    intelPackages.mkl
    level-zero
    tbb
    blas.dev
    lapack.dev
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    broken = true;
    changelog = "https://github.com/oneapi-src/oneMKL/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Math Kernel Library (oneMKL) Interfaces";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
