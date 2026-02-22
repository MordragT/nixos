{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  wayland,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-bg-theme";
  version = "unstable-2026-02-03";

  src = fetchFromGitHub {
    owner = "wash2";
    repo = "cosmic_ext_bg_theme";
    rev = "8856cab26546338a65fac7b8f7d579299fe4a479";
    hash = "";
  };

  cargoHash = "";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
    wayland
  ];

  meta = {
    description = "Unofficial service for syncing the theme with the wallpaper for the COSMIC(tm) desktop.";
    homepage = "https://github.com/wash2/cosmic_ext_bg_theme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "cosmic-ext-bg-theme";
  };
}
