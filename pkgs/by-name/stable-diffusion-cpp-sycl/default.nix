{
  lib,
  intel-sycl,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  autoAddDriverRunpath,
  oneapi-tbb,
  oneapi-dnn,
  oneapi-math,
  level-zero,
  ocl-icd,
  opencl-headers,
}:
let
  inherit (lib)
    cmakeBool
    cmakeFeature
    optionals
    optionalString
    ;
in
intel-sycl.stdenv.mkDerivation (finalAttrs: {
  pname = "stable-diffusion-cpp";
  version = "master-453-4ff2c8c";

  src = fetchFromGitHub {
    owner = "leejet";
    repo = "stable-diffusion.cpp";
    rev = finalAttrs.version;
    hash = "sha256-8cN6dYOQAKnJpuQdtayp6+o71s64lG+FcTn8GsIM4jI=";
    fetchSubmodules = true;
  };

  patches = [
    ./fast-math.patch
    ./ggml-onemath.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    oneapi-tbb
    oneapi-dnn
    oneapi-math
    level-zero
    ocl-icd
    opencl-headers
  ];

  cmakeFlags = [
    (cmakeBool "SD_BUILD_EXAMPLES" true)
    (cmakeBool "SD_BUILD_SHARED_LIBS" true)
    (cmakeBool "SD_USE_SYSTEM_GGML" false)
    (cmakeBool "SD_SYCL" true)
    (cmakeBool "SD_CUDA" false)
    (cmakeBool "SD_HIPBLAS" false)
    (cmakeBool "SD_VULKAN" false)
    (cmakeBool "SD_OPENCL" false)
    (cmakeBool "SD_METAL" false)
    (cmakeBool "SD_FAST_SOFTMAX" false)
    (cmakeBool "GGML_SYCL_F16" true) # not sure if this is a good idea
  ];

  meta = with lib; {
    description = "Stable Diffusion inference in pure C/C++";
    homepage = "https://github.com/leejet/stable-diffusion.cpp";
    license = licenses.mit;
    mainProgram = "sd";
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = platforms.linux;
  };
})
