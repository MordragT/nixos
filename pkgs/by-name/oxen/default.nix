{
  fetchFromGitHub,
  rustPlatform,
  cmake,
  pkg-config,
  openssl,
  libclang,
  rocksdb,
}:
rustPlatform.buildRustPackage rec {
  pname = "oxen";
  version = "0.42.3";
  sourceRoot = "source/oxen-rust";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-n4Js7qsR2Qd1SmQuJIAbrEKh6WAQsTW0x76dc2IlIzU=";
  };

  cargoHash = "sha256-74IxNJ7A5Uxo59GXdEL+6Gm1uhITq/ai7zf4CT7XZGk=";

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
