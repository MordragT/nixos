{
  lib,
  intel-sycl,
  fetchFromGitHub,
  cmake,
  oneapi-tbb,
  opencl-headers,
  oneapi-math-sycl-blas,
}:
intel-sycl.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-math";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneMath";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jVcrpne6OyOeUlQHg07zZXEyFXvEGCYW88sWnYgEeu8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_GENERIC_BLAS_BACKEND" true)

    (lib.cmakeBool "ENABLE_MKLCPU_BACKEND" false)
    (lib.cmakeBool "ENABLE_MKLGPU_BACKEND" false)
    (lib.cmakeBool "ENABLE_MKLCPU_THREAD_TBB" true)

    (lib.cmakeBool "BUILD_FUNCTIONAL_TESTS" false)
    (lib.cmakeBool "BUILD_EXAMPLES" false)
  ];

  buildInputs = [
    oneapi-tbb
    opencl-headers
    oneapi-math-sycl-blas
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
