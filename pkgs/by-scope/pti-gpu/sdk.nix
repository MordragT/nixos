{
  src,
  version,
  intel-llvm-bin,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  autoAddDriverRunpath,
  addDriverRunpath,
  ocl-icd,
  spdlog,
}: let
  # From the cmake file:
  # Why version 1.14.0?
  # It is an IPEX requirement for PTI to link against the LTS version of the
  # Level Zero Loader.
  level-zero = intel-llvm-bin.stdenv.mkDerivation rec {
    pname = "level-zero";
    version = "1.14.0";

    src = fetchFromGitHub {
      owner = "oneapi-src";
      repo = "level-zero";
      rev = "refs/tags/v${version}";
      hash = "sha256-7hFGY255dLgDo93+Nx2we/cfEtwaiaajdVg1VTst1/U=";
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
  intel-llvm-bin.stdenv.mkDerivation {
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
    ];
  }
