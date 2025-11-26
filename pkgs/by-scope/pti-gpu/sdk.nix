{
  src,
  version,
  intel-sycl,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  addDriverRunpath,
  autoAddDriverRunpath,
  ocl-icd,
  spdlog,
}: let
  # From the cmake file:
  # Why version 1.24.2?
  # It is an IPEX requirement for PTI to link against the LTS version of the
  # Level Zero Loader.
  level-zero = intel-sycl.stdenv.mkDerivation rec {
    pname = "level-zero";
    version = "1.24.2";

    src = fetchFromGitHub {
      owner = "oneapi-src";
      repo = "level-zero";
      rev = "refs/tags/v${version}";
      hash = "sha256-5QkXWuMFNsYNsW8lgo9FQIZ5NuLiRZCFKGWedpddi8Y=";
    };

    nativeBuildInputs = [
      cmake
      addDriverRunpath
    ];

    postFixup = ''
      addDriverRunpath $out/lib/libze_loader.so
    '';
  };
in
  intel-sycl.stdenv.mkDerivation {
    pname = "pti-gpu-sdk";
    inherit src version;

    sourceRoot = "source/sdk";

    nativeBuildInputs = [
      cmake
      pkg-config
      python3
      autoAddDriverRunpath
    ];

    buildInputs = [
      level-zero
      ocl-icd
      spdlog
    ];

    cmakeFlags = [
      "-DPTI_BUILD_TESTING=OFF"
      "-DPTI_BUILD_SAMPLES=OFF"
      "-DPTI_ENABLE_LOGGING=ON"
    ];
  }
