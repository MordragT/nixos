{ stdenv
, lib
, fetchFromGitHub
, wrapGAppsHook
, runCommand
, meson
, ninja
, pkg-config
, openssl
, rustPlatform
, libadwaita
, gtk4
, libpanel
, desktop-file-utils
}:
stdenv.mkDerivation rec {
  pname = "epic-asset-manager";
  version = "3.8.3";

  src =
    let
      source = fetchFromGitHub {
        owner = "AchetaGames";
        repo = "Epic-Asset-Manager";
        rev = "a07c4591fcc1584b599dc5aafc725b22b483397d";
        sha256 = "CrRB+MKszNsI55SICHRd85PPb5Ss/OYrPZRCigkUyMc=";
      };
    in
    runCommand "source" { } ''
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
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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
