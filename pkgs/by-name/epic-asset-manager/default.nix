{
  stdenv,
  lib,
  fetchFromGitHub,
  wrapGAppsHook3,
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
let
  version = "3.9.4";
in
stdenv.mkDerivation {
  pname = "epic-asset-manager";
  inherit version;

  src = fetchFromGitHub {
    owner = "AchetaGames";
    repo = "Epic-Asset-Manager";
    rev = "v${version}";
    sha256 = "";
  };

  cargoHash = "";

  nativeBuildInputs = [
    wrapGAppsHook3
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
    maintainers = with maintainers; [ mordrag ];
    description = "A frontend to Assets purchased on Epic Games Store";
    platforms = platforms.linux;
  };
}
