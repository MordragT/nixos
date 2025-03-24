{
  lib,
  intel-dpcpp,
  fetchFromGitHub,
  gnumake,
  oneapi-tbb,
  oneapi-math,
}:
# requires dpcpp compiler
intel-dpcpp.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-dal";
  version = "2025.2.0";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneDAL";
    rev = finalAttrs.version;
    hash = "";
  };

  nativeBuildInputs = [
    gnumake
  ];

  makeFlags = [
    "TBBROOT=${oneapi-tbb}"
    "MKLROOT=${oneapi-math}"
  ];

  buildInputs = [
    oneapi-tbb
    oneapi-math
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    broken = true; # wait for sane build system changes before attempting it again
    changelog = "https://github.com/uxlfoundation/oneDAL/releases/tag/${finalAttrs.version}";
    description = "oneAPI Data Analytics Library (oneDAL)";
    homepage = "https://01.org/oneDAL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
