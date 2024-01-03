{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  oneTBB,
}:
# requires dpcpp compiler
stdenv.mkDerivation (finalAttrs: {
  pname = "oneDAL";
  version = "2024.0.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDAL";
    rev = finalAttrs.version;
    hash = "";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    oneTBB
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    changelog = "https://github.com/oneapi-src/oneDAL/releases/tag/${finalAttrs.version}";
    description = "oneAPI Data Analytics Library (oneDAL)";
    homepage = "https://01.org/oneDAL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
