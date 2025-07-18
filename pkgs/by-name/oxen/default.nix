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
  version = "0.36.1";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-R6qTDZaw1Lg/xQ95XBn5HkYDBCz0aQn4cByE47JSFOI=";
  };

  cargoBuildFlags = "--bin oxen --all-features";
  useFetchCargoVendor = true;
  cargoHash = "sha256-BmVv0E7uPBhrYh63AxNxJpGRSbq5c5Id+F6soUdvwpo=";

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
