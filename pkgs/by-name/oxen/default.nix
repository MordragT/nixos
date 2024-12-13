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
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-odWxrL68SK1gitSFpwVz0PXIDMv5BnrziHN+k8PIQ2k=";
  };

  cargoBuildFlags = "--bin oxen --all-features";
  cargoHash = "sha256-aQvO3xwjV4UJ1Q/9qOYrsLlO5B0eHcYcvl/qBXVbx7U=";

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
