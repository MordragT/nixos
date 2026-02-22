{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-calendar";
  version = "unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "calendar";
    rev = "9bf0de542482be25fadbbed0ce32bfdaadf0e928";
    hash = "";
  };

  cargoHash = "";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-calendar"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A calendar application for the COSMIC desktop.";
    homepage = "https://github.com/cosmic-utils/calendar";
    # license = lib.licenses.gpl3Only; TODO not specified yet
    mainProgram = "cosmic-ext-calendar";
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.linux;
    broken = true; # requires cosmic accounts (broken too)
  };
}
