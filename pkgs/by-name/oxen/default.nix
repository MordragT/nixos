{
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  libclang,
  rocksdb,
}:
rustPlatform
.buildRustPackage rec {
  pname = "oxen";
  version = "0.18.9";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-I/zevcNkFkMiFKO7WlnKNvaYYJk2G7Gfas2vDqvF+G4=";
  };

  cargoBuildFlags = "--bin oxen --all-features";
  cargoHash = "sha256-uIDuuqYUpm4+2ynnktGL/PfmwK4I4OJyCuSQ5V871vI=";

  doCheck = false;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  buildInputs = [
    openssl
    libclang
    rocksdb
  ];
}
