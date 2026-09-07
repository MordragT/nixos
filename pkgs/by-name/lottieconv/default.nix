{
  fetchCrate,
  rustPlatform,
  rlottie,
  clang,
  libclang,
  pkg-config,
  openssl,
}:
let
  pname = "lottieconv";
  version = "0.3.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

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
