{
  lib,
  intelPackages,
  fetchFromGitHub,
  gnumake,
  tbb,
}:
# requires dpcpp compiler
intelPackages.env.mkDerivation (finalAttrs: {
  pname = "oneapi-dal";
  version = "2024.0.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDAL";
    rev = finalAttrs.version;
    hash = "sha256-LdeeecnlBELXeVk/Qywl4qzFkcIs3sIGh9lnixfw0r8=";
  };

  nativeBuildInputs = [
    gnumake
  ];

  makeFlags = [
    "TBBROOT=${tbb}"
  ];

  buildInputs = [
    tbb
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    broken = true;
    changelog = "https://github.com/oneapi-src/oneDAL/releases/tag/${finalAttrs.version}";
    description = "oneAPI Data Analytics Library (oneDAL)";
    homepage = "https://01.org/oneDAL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
})
