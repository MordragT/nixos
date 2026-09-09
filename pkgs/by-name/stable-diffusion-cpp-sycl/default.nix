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
  inherit (lib) cmakeBool cmakeFeature;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stable-diffusion-cpp";
  version = "master-849-d04e895";

  src = fetchFromGitHub {
    owner = "leejet";
    repo = "stable-diffusion.cpp";
    rev = finalAttrs.version;
    hash = "sha256-87tEPKu8xq611fa2/tXvWujl3dypniL+DVrczKP34Qs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    ggml-sycl
  ];

  cmakeFlags = [
    # sadly needs to be set as the feature in ggml-sycl
    # doesn't propagate
    (cmakeFeature "CMAKE_CXX_FLAGS" "-DGGML_MAX_NAME=128")
    (cmakeBool "SD_BUILD_EXAMPLES" true) # server, cli
    (cmakeBool "SD_BUILD_SHARED_LIBS" true)
    (cmakeBool "SD_USE_SYSTEM_GGML" true)
  ];

  meta = with lib; {
    description = "Stable Diffusion inference in pure C/C++";
    homepage = "https://github.com/leejet/stable-diffusion.cpp";
    license = licenses.mit;
    mainProgram = "sd";
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = platforms.linux;
    # currently waiting for int8 related changes being upstreamed
    # https://github.com/ggml-org/llama.cpp/pull/28480
    broken = true;
  };
})
