{
  lib,
  dpcenv,
  fetchFromGitHub,
  cmake,
  level-zero,
  oneTBB,
  mkl,
  blas,
  lapack,
}:
# requires dpcpp compiler
dpcenv.mkDerivation (finalAttrs: {
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
    (blas.override {
      blasProvider = mkl;
      isILP64 = true;
    })
    (lapack.override {
      lapackProvider = mkl;
      isILP64 = true;
    })
    mkl
    # https://github.com/NixOS/nixpkgs/issues/245030 ??
    # (mkl.overrideAttrs (orig: {
    #   postFixup =
    #     ''
    #       ln -s $out/lib/libmkl_rt.so $out/lib/libblas64.so
    #       ln -s $out/lib/libmkl_rt.so $out/lib/libcblas64.so
    #       ln -s $out/lib/libmkl_rt.so $out/lib/liblapack64.so
    #       ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke64.so

    #       ln -s $out/lib/libmkl_rt.so $out/lib/libblas64.so.3
    #       ln -s $out/lib/libmkl_rt.so $out/lib/libcblas64.so.3
    #       ln -s $out/lib/libmkl_rt.so $out/lib/liblapack64.so.3
    #       ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke64.so.3
    #     ''
    #     + orig.postFixup;
    # }))
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
