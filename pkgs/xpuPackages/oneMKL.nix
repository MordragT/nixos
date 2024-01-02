{
  cmake,
  fetchFromGitHub,
  lib,
  xpuPackages,
  level-zero,
}:
xpuPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "oneMKL";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneMKL";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RQnAsjnzBZRCPbXtDDWEYHlRjY6YAP5mEwr/7CpcTYw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
  ];

  buildInputs = [
    level-zero
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    changelog = "https://github.com/oneapi-src/oneMKL/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Math Kernel Library (oneMKL) Interfaces ";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
