{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
# requires dpcpp compiler
stdenv.mkDerivation (finalAttrs: {
  pname = "oneCCL";
  version = "2021.11.2";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneCCL";
    rev = finalAttrs.version;
    hash = "";
  };

  nativeBuildInputs = [
    cmake
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    changelog = "https://github.com/oneapi-src/oneCCL/releases/tag/${finalAttrs.version}";
    description = "oneAPI Collective Communications Library (oneCCL)";
    homepage = "https://01.org/oneCCL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
