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
  version = "0.36.3";
  sourceRoot = "source/oxen-rust";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-NeaM7Wd7A59hO5d+7Ikrn3dBj0vNFw+7xIJY7TCPSYQ=";
  };

  cargoHash = "sha256-qPR8LxocXTFXI4LjN3uNXw0Xlih6AjF+jAhdjg8Hetc=";

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
