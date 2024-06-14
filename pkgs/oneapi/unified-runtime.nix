{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  libbacktrace,
  level-zero,
  numactl,
  unified-memory-framework,
}:
stdenv.mkDerivation {
  pname = "unified-runtime";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-runtime";
    rev = "6ccaf38708cfa614ab7f9b34c351826cd74028f2";
    hash = "sha256-Gcuh9mzV7X6yWqWmYYdhtySBySVVrxNEMChcrobg38c=";
  };

  patches = [
    ./umf.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DUR_BUILD_TESTS=OFF"
    "-DUR_BUILD_ADAPTER_L0=ON"
    "-DL0_LIBRARY=${level-zero}/lib/libze_loader.so"
    "-DL0_INCLUDE_DIR=${level-zero}/include"
  ];

  buildInputs = [
    python3
    libbacktrace
    level-zero
    numactl
    unified-memory-framework
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    # changelog = "https://github.com/oneapi-src/unified-runtime/releases/tag/v${finalAttrs.version}";
    description = "oneAPI unified runtime";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
}
