{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  level-zero,
  hwloc,
  numactl,
}:
stdenv.mkDerivation rec {
  pname = "unified-memory-framework";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = pname;
    rev = "9bf7a0dc4dff76844e10edbb5c6e9d917536ef6d";
    hash = "sha256-2yJqZXpqI/dEP+movt8h0hyFgxxPNuQ9lIjNa8+X6Ns=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    level-zero
    hwloc
    numactl
  ];

  cmakeFlags = [
    "-DUMF_BUILD_TESTS=OFF"
    "-DUMF_BUILD_EXAMPLES=OFF"
    "-DUMF_BUILD_LIBUMF_POOL_DISJOINT=ON"
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    description = "A library for constructing allocators and memory pools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.all;
  };
}
