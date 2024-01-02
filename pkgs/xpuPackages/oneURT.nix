{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  python3,
  libbacktrace,
  level-zero,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oneURT";
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
    # TODO why ever this is not working
    "-DUR_BUILD_ADAPTER_L0=OFF"
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
