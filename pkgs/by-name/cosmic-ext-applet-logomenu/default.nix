{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-applet-logomoenu";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "cappsyco";
    repo = "cosmic-ext-applet-logomenu";
    rev = "v${version}";
    hash = "sha256-iIPVGpBLUm8u9jZs8c4LafG/epWTUxWPbpSxFoSB8Zo=";
  };

  cargoHash = "sha256-LxTSmEHHyhfCV4eK0EaCp/FHI02FYmOy4NqZgTKTXOU=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src1"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-logomenu"
    "--set"
    "bin-src2"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-logomenu-settings"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "https://github.com/cappsyco/cosmic-ext-applet-logomenu";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "cosmic-ext-applet-logomenu";
  };
}
