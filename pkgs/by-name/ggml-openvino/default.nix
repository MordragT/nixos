{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  oneapi-tbb,
  openvino-gpu,
  ocl-icd,
  opencl-headers,
  opencl-clhpp,
}:
let
  inherit (lib) cmakeBool cmakeFeature;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ggml";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "ggml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a/NtFGX7jYITnj6EWE6+H2eyhsKutn0k4IiStihOagA=";
  };

  # Disable automatic stripping completely
  dontStrip = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    oneapi-tbb
    openvino-gpu
    ocl-icd
    opencl-headers
    opencl-clhpp
  ];

  cmakeFlags = [
    (cmakeFeature "CMAKE_CXX_FLAGS" "-w -DGGML_MAX_NAME=128") # needed for stable-diffusion.cpp
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "GGML_NATIVE" false)

    # Enable some CPU features targetting x86_64_v3 (Haswell and newer)
    (cmakeBool "GGML_SSE42" true)
    (cmakeBool "GGML_AVX" true)
    (cmakeBool "GGML_AVX2" true)
    (cmakeBool "GGML_FMA" true)
    (cmakeBool "GGML_F16C" true)
    (cmakeBool "GGML_BMI2" true)

    (cmakeBool "GGML_OPENVINO" true)
  ];

  # The cmake package does not handle absolute CMAKE_INSTALL_LIBDIR and CMAKE_INSTALL_INCLUDEDIR
  # correctly.
  # Tracking: https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace ggml.pc.in \
      --replace-fail \
        "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" \
        "@CMAKE_INSTALL_FULL_INCLUDEDIR@" \
      --replace-fail \
        "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" \
        "@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  meta = {
    description = "Tensor library for machine learning";
    homepage = "https://github.com/ggml-org/ggml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.all;
  };
})
