{
  lib,
  intel-llvm-bin,
  fetchFromGitHub,
  cmake,
  oneapi-tbb,
}:
intel-llvm-bin.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-dpl";
  version = "2022.7.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDPL";
    rev = "release/${finalAttrs.version}";
    hash = "sha256-mNQl9IILaZEeEFc0TVQnxSEVUrvenAY+W/q28Ts3uEE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    oneapi-tbb
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    changelog = "https://github.com/oneapi-src/oneDPL/releases/tag/oneDPL-${finalAttrs.version}-rc1";
    description = " oneAPI DPC++ Library (oneDPL)";
    homepage = "https://01.org/oneDPL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
