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
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-kx0w3EGKx7FtCQiihW4YX6LMqofcm9+lCTiFimg5LBI=";
  };

  cargoBuildFlags = "--bin oxen --all-features";
  cargoHash = "sha256-xL4tOWfXSfBtYV9EU7I9HG2ubYehCxMTd41xr8Y95s8=";

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
