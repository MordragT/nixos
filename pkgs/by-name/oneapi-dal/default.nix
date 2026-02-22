{
  lib,
  bazel_8,
  bazelPackage,
  fetchFromGitHub,
  intel-sycl,
  oneapi-tbb,
  oneapi-math,
}:
# requires dpcpp compiler
bazelPackage.override { inherit (intel-sycl) stdenv; } rec {
  name = "oneapi-dal";
  version = "2025.9.0";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneDAL";
    rev = version;
    hash = "sha256-RhRqENQh/Ro0aqHCHeTGv+42sSn58E9Dm9bjQpolnQg=";
  };

  registry = fetchFromGitHub {
    owner = "bazelbuild";
    repo = "bazel-central-registry";
    rev = "ffe6744fa1973c113dd73d46bc6ee0e82341052b";
    hash = "";
  };

  bazel = bazel_8;
  targets = [
    "//:release"
  ];

  nativeBuildInputs = [
  ];

  buildInputs = [
    oneapi-tbb
    oneapi-math
  ];

  postPatch = ''
    # bazel 8.4.2 should work just as well as bazel 8.4.0
    rm -f .bazelversion
    patchShebangs .
  '';

  installPhase = ""; # TODO

  bazelRepoCacheFOD = {
    outputHash = "";
    outputHashAlgo = "sha256";
  };

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    broken = true; # Needs strip but this is not distributed with intel-dpcpp
    changelog = "https://github.com/uxlfoundation/oneDAL/releases/tag/${version}";
    description = "oneAPI Data Analytics Library (oneDAL)";
    homepage = "https://01.org/oneDAL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.all;
  };
}
