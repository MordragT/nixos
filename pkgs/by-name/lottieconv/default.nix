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
  version = "0.3.0";
  src = fetchCrate {
    inherit pname version;
    sha256 = "";
  };
  cargoBuildFlags = "--bin lottie2webp --all-features";
  cargoHash = "";

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
