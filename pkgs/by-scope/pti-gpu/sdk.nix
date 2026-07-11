{
  src,
  version,
  intel-llvm,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  addDriverRunpath,
  autoAddDriverRunpath,
  ocl-icd,
  spdlog,
}:
let
  # From the cmake file:
  # Why version 1.28.5?
  # It is an IPEX requirement for PTI to link against the LTS version of the
  # Level Zero Loader.
  level-zero = intel-llvm.stdenv.mkDerivation rec {
    pname = "level-zero";
    version = "1.28.5";

    src = fetchFromGitHub {
      owner = "oneapi-src";
      repo = "level-zero";
      rev = "refs/tags/v${version}";
      hash = "sha256-g97BgCR/ca9Xv2l3Kbyuez8vWY6Jwrwt6Dmw3DGhPaY=";
    };

    nativeBuildInputs = [
      cmake
      addDriverRunpath
    ];

    postFixup = ''
      addDriverRunpath $out/lib/libze_loader.so
    '';
  };

  ittapi = fetchFromGitHub {
    owner = "intel";
    repo = "ittapi";
    # https://github.com/intel/pti-gpu/blob/a5bab309f4ffdd78bd127035c46f5f75371160f8/sdk/cmake/Modules/macros.cmake#L350
    rev = "v3.26.8";
    sha256 = "sha256-cxqwclXuS2LBB0Vc81fDVpfGUve/1tWKnugppBwBhGc=";
  };
in
intel-llvm.stdenv.mkDerivation {
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
    "-DFETCHCONTENT_SOURCE_DIR_ITTAPI=${ittapi}"
  ];
}
