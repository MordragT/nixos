{
  stdenv,
  lib,
  fetchFromGitHub,
  wrapGAppsHook,
  runCommand,
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
  version = "3.8.3";

  src = let
    source = fetchFromGitHub {
      owner = "AchetaGames";
      repo = "Epic-Asset-Manager";
      rev = "a07c4591fcc1584b599dc5aafc725b22b483397d";
      sha256 = "CrRB+MKszNsI55SICHRd85PPb5Ss/OYrPZRCigkUyMc=";
    };
  in
    runCommand "source" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${./epic-asset-manager.lock} $out/Cargo.lock
    '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./epic-asset-manager.lock;
  };

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
