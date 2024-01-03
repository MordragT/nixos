{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  libbacktrace,
  level-zero,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unified-runtime";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-runtime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hIr8QfidMs4XjQ8CTqdph6peRUdmgP3WWZcE9+AZ1Vs=";
  };

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
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    changelog = "https://github.com/oneapi-src/unified-runtime/releases/tag/v${finalAttrs.version}";
    description = "oneAPI unified runtime";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
