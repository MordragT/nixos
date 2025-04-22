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
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "oxen-ai";
    repo = "oxen";
    rev = "v${version}";
    sha256 = "sha256-RVJtieouNMcqh8KqO5e8Wcir9+ilT+nPl/dWTI+A9cg=";
  };

  cargoBuildFlags = "--bin oxen --all-features";
  useFetchCargoVendor = true;
  cargoHash = "sha256-vaYCP8+tkDDhDsggBAlybqk8fN4aW7BzGFip2cI1Eho=";

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
