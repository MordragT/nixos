{
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  openssl,
  libclang,
  rocksdb,
}:
rustPlatform
.buildRustPackage rec {
  pname = "oxen";
  version = "0.38.4";
  sourceRoot = "source/oxen-rust";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-zkt7c3Y7un+KDktYrSIT5nSJHZo7b4yNvOJXjwfpquA=";
  };

  cargoHash = "sha256-0fCJUgrePwhLD3nviDo/a9MnSYBPxkZSxkxjZ5/pcZ0=";

  doCheck = false;

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
    cmake
  ];

  buildInputs = [
    openssl
    libclang
    rocksdb
  ];
}
