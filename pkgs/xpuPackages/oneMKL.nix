{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  level-zero,
  oneTBB,
  mkl,
  sycl,
}:
# requires dpcpp compiler
stdenv.mkDerivation (finalAttrs: {
  pname = "oneMKL";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneMKL";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RQnAsjnzBZRCPbXtDDWEYHlRjY6YAP5mEwr/7CpcTYw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    # "-DMKL_INCLUDE=./include/openapi/mkl/"
  ];

  buildInputs = [
    level-zero
    oneTBB
    (mkl.overrideAttrs (orig: {
      postFixup =
        ''
          ln -s $out/lib/libmkl_rt.so $out/lib/libblas64.so
          ln -s $out/lib/libmkl_rt.so $out/lib/libcblas64.so
          ln -s $out/lib/libmkl_rt.so $out/lib/liblapack64.so
          ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke64.so

          ln -s $out/lib/libmkl_rt.so $out/lib/libblas64.so.3
          ln -s $out/lib/libmkl_rt.so $out/lib/libcblas64.so.3
          ln -s $out/lib/libmkl_rt.so $out/lib/liblapack64.so.3
          ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke64.so.3

          ln -s $out/include/mkl_blas.h $out/include/blas.h
          ln -s $out/include/mkl_blas64.h $out/include/blas64.h
          ln -s $out/include/mkl_cblas.h $out/include/cblas.h
          ln -s $out/include/mkl_cblas64.h $out/include/cblas64.h
          ln -s $out/include/mkl_lapack.h $out/include/lapack.h
          ln -s $out/include/mkl_lapacke.h $out/include/lapacke.h
        ''
        + orig.postFixup;
    }))
    sycl
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    changelog = "https://github.com/oneapi-src/oneMKL/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Math Kernel Library (oneMKL) Interfaces";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
