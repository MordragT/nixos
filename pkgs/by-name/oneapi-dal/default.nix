{
  lib,
  bazel_7,
  buildBazelPackage,
  fetchFromGitHub,
  intel-dpcpp,
  oneapi-tbb,
  oneapi-math,
}:
# requires dpcpp compiler
buildBazelPackage.override {inherit (intel-dpcpp) stdenv;} rec {
  pname = "oneapi-dal";
  version = "2025.4.0";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneDAL";
    rev = version;
    hash = "sha256-Kbt7PSsmCFpI0QL5ximePUKM3DDh0V6LPiSWUk87M8k=";
  };

  bazel = bazel_7;
  bazelTargets = [
    "//:release"
  ];

  nativeBuildInputs = [
  ];

  buildInputs = [
    oneapi-tbb
    oneapi-math
  ];

  postPatch = ''
    # bazel 7.6 should work just as well as bazel 7.4.1
    rm -f .bazelversion
    patchShebangs .
  '';

  fetchAttrs.sha256 = "";
  buildAttrs = {};

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    broken = true; # Needs strip but this is not distributed with intel-dpcpp
    changelog = "https://github.com/uxlfoundation/oneDAL/releases/tag/${version}";
    description = "oneAPI Data Analytics Library (oneDAL)";
    homepage = "https://01.org/oneDAL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
}
