{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-weather";
  version = "unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ext-applet-weather";
    rev = "3a1780a61dd44a02eb9115209f8b30917d12d4c9";
    hash = "sha256-MRCF4sGJkqPHCOdEyPGe5L7fsqKArYQ0iXqyMQZsbO4=";
  };

  cargoHash = "sha256-1lIWzCqpIxk+FWA/84yN/x10Se2xRTZ7KEqAWVgfFgU=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-weather"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Simple weather info applet for cosmic";
    homepage = "https://github.com/cosmic-utils/cosmic-ext-applet-weather";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "cosmic-ext-applet-weather";
  };
}
