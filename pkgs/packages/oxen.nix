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
  version = "0.15.8";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-ySQAgaI318SS9BnTEI8X2Jck7JM4UqTq2PdQUeeHqVw=";
  };

  cargoBuildFlags = "--bin oxen --all-features";
  cargoSha256 = "sha256-YKJz9tBgQrFCasqHSYjFOBjQvLAiLgiJLqp8oUj9/mc=";

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
