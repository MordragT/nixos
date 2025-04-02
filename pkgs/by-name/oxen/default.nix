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
  version = "0.32.2";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-YE4Vep2SCzYZ1RKpyT6Ud9oWgyFdlzCaCaytoiR1DxM=";
  };

  cargoBuildFlags = "--bin oxen --all-features";
  useFetchCargoVendor = true;
  cargoHash = "sha256-Bi42DJBTaDceMv1BBjD6yYxI/1O24OtLs86mMHA1J8M=";

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
