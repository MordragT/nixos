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
  version = "0.40.2";
  sourceRoot = "source/oxen-rust";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-kihXQ4w4V8GfZpwrk/9kfZjpPV1s4NGs+0mnjghFZaU=";
  };

  cargoHash = "sha256-lOwQ1nw4wsN+UK6oYcATTcGhsa4nd2kGlIMxl/xxW0k=";

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
