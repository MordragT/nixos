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
stdenv.mkDerivation rec {
  pname = "epic-asset-manager";
  version = "3.8.6";

  src = let
    source = fetchFromGitHub {
      owner = "AchetaGames";
      repo = "Epic-Asset-Manager";
      rev = "${version}";
      sha256 = "";
    };
  in
    runCommand "source" {} ''
      cp -R ${source} $out
      chmod +w $out
      cp ${./Cargo.lock} $out/Cargo.lock
    '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
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
