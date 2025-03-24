{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  level-zero,
  hwloc,
  numactl,
  oneapi-tbb,
}:
stdenv.mkDerivation rec {
  pname = "unified-memory-framework";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-57n/IDlskUNHR1QSqpomKQ2tcaKFBMMWabAzmso5SdQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    level-zero
    hwloc
    numactl
    oneapi-tbb
  ];

  cmakeFlags = [
    "-DUMF_BUILD_TESTS=OFF"
    "-DUMF_BUILD_EXAMPLES=OFF"
    "-DUMF_BUILD_LIBUMF_POOL_DISJOINT=ON"
    "-DUMF_BUILD_LEVEL_ZERO_PROVIDER=ON"
    "-DUMF_BUILD_CUDA_PROVIDER=OFF"
    "-DUMF_BUILD_SHARED_LIBRARY=ON"
    "-DUMF_LEVEL_ZERO_INCLUDE_DIR=${level-zero}/include/level_zero"
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    description = "A library for constructing allocators and memory pools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
}
