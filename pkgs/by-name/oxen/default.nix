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
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-plxDN1CPeHQc15gsZ9ylMzZx1O4OVPVn8369gLbcC/c=";
  };

  cargoBuildFlags = "--bin oxen --all-features";
  useFetchCargoVendor = true;
  cargoHash = "sha256-+seWicXPXRPZNRdLGzBvTN/H8Ha65GvvH+kOmCNXm3U=";

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
