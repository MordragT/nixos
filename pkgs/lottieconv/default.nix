{
  fetchCrate,
  rustPlatform,
  rlottie,
  clang,
  libclang,
  pkg-config,
  openssl,
}:
rustPlatform
.buildRustPackage rec {
  pname = "lottieconv";
  version = "0.1.2";
  src = fetchCrate {
    inherit pname version;
    sha256 = "Q5iXdd2+CHUbTesgrevG+FR410HiABKVjtsTBfTNn3s=";
  };
  cargoBuildFlags = "--bin lottie2webp --all-features";
  cargoSha256 = "HTaQ9xBxCw79zxM6hFH/r5uqt1bBZpIDDWGS1lASMUU=";

  PKG_CONFIG_PATH = "${rlottie}/lib/pkgconfig";
  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${rlottie}/include";

  nativeBuildInputs = [
    clang
    libclang
    pkg-config
    openssl
    rlottie
  ];
}
