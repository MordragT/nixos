{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  ggml-sycl,
}:
let
  inherit (lib) cmakeBool;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stable-diffusion-cpp";
  version = "master-849-d04e895";

  src = fetchFromGitHub {
    owner = "leejet";
    repo = "stable-diffusion.cpp";
    rev = finalAttrs.version;
    hash = "";
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
    ggml-sycl
  ];

  cmakeFlags = [
    (cmakeBool "SD_BUILD_EXAMPLES" true)
    (cmakeBool "SD_BUILD_SHARED_LIBS" true)
    (cmakeBool "SD_USE_SYSTEM_GGML" true)
    (cmakeBool "SD_SYCL" true)
    (cmakeBool "SD_CUDA" false)
    (cmakeBool "SD_HIPBLAS" false)
    (cmakeBool "SD_VULKAN" false)
    (cmakeBool "SD_OPENCL" false)
    (cmakeBool "SD_METAL" false)
    (cmakeBool "SD_FAST_SOFTMAX" false)
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
