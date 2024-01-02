{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  tbb_2021_8,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "oneDPL";
  version = "2022.3.0";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDPL";
    rev = "release/2022.3";
    hash = "sha256-22fbB89iHJ9SJlvDOZ4g4mlFHuxC0uxe9HNl2HIPISs=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    tbb_2021_8
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
