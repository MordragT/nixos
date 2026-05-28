{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:
let
  version = "0.1.3";
in
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-gamemode-status";
  inherit version;

  src = fetchFromGitHub {
    owner = "d-brox";
    repo = "cosmic-ext-applet-gamemode-status";
    rev = "v${version}";
    hash = "";
  };

  cargoHash = "";

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
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-gamemode-status"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/d-brox/cosmic-ext-applet-gamemode-status";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "cosmic-ext-applet-gamemode-status";
  };
}
