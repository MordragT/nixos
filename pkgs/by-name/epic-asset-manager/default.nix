{
  stdenv,
  lib,
  fetchFromGitHub,
  wrapGAppsHook,
  meson,
  ninja,
  pkg-config,
  openssl,
  cargo,
  rustc,
  rustPlatform,
  libadwaita,
  gtk4,
  libpanel,
  desktop-file-utils,
}:
stdenv.mkDerivation {
  pname = "epic-asset-manager";
  version = "unstable-2025-05-19";

  src = fetchFromGitHub {
    owner = "AchetaGames";
    repo = "Epic-Asset-Manager";
    rev = "$b8b36b88c145398a3938faa59eda15b3551d3400";
    sha256 = "";
  };

  cargoHash = "";

  nativeBuildInputs = [
    wrapGAppsHook
    meson
    pkg-config
    openssl
    ninja
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    libadwaita
    gtk4
    libpanel
    desktop-file-utils
  ];

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [mordrag];
    description = "A frontend to Assets purchased on Epic Games Store";
    platforms = platforms.linux;
  };
}
