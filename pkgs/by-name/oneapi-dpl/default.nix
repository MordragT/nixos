{
  lib,
  dpcppStdenv,
  fetchFromGitHub,
  cmake,
  intel-tbb,
}:
dpcppStdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-dpl";
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
    intel-tbb
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
