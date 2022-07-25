{ system
, lib
, pkgs
}:
(pkgs.makeRustPlatform {
  inherit (pkgs.fenix.minimal) cargo rustc;
}).buildRustPackage rec {
  pname = "lottieconv";
  version = "0.1.2";
  # src = let
  #     source = pkgs.fetchFromGitHub {
  #         owner = "msrd0";
  #         repo = "rlottie-rs";
  #         rev = "e83ef53cf29e5b667768200d4a11344fe52e0d06";
  #         sha256 = "GrSNyvqNNhUivCEkGxH0KeM9/MRIu5Dn2sZkXooyfvw=";
  #     };
  # in
  #     pkgs.runCommand "source" {} ''
  #     cp -R ${source}/lottieconv/ $out
  #     chmod +w $out
  #     cp ${./lottieconv.lock} $out/Cargo.lock
  #     '';
  src = pkgs.fetchCrate {
    inherit pname version;
    sha256 = "Q5iXdd2+CHUbTesgrevG+FR410HiABKVjtsTBfTNn3s=";
  };

  # buildNoDefaultFeatures = true;
  # buildFeatures = [ "webp" "gif" ];
  # checkFeatures = [ "webp" "gif" ];
  cargoBuildFlags = "--bin lottie2webp --all-features";
  #buildAndTestSubdir = "./lottieconv/bin/lottie2webp.rs";

  cargoSha256 = "HTaQ9xBxCw79zxM6hFH/r5uqt1bBZpIDDWGS1lASMUU=";
  # cargoSha256 = "ZSOplGyNfqO09Mt9/qEcsK8DoTgkg8xSB7wWmP5cCDc=";

  PKG_CONFIG_PATH = "${pkgs.rlottie}/lib/pkgconfig";
  LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${pkgs.rlottie}/include";

  nativeBuildInputs = with pkgs; [
    clang
    libclang
    pkgconfig
    openssl
    rlottie
  ];
}
