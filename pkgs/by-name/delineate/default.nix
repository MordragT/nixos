{
  stdenv,
  lib,
  fetchFromGitHub,
  wrapGAppsHook,
  meson,
  ninja,
  cmake,
  pkg-config,
  openssl,
  cargo,
  rustc,
  rustPlatform,
  libadwaita,
  gtk4,
  gtksourceview5,
  webkitgtk_6_0,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "delineate";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "SeaDve";
    repo = "Delineate";
    rev = "v${version}";
    sha256 = "sha256-dFGh7clxc6UxQRTsNKrggWDvL3CPmzJmrvO1jqMVoTg=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-RtQnpbjULtnvlc71L4KIKPES0WRSY2GoaIwt8UvlYOA=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    meson
    cmake
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
    gtksourceview5
    webkitgtk_6_0
    desktop-file-utils
  ];

  meta = with lib; {
    license = licenses.gpl3;
    maintainers = with maintainers; [mordrag];
    description = "View and edit graphs";
    platforms = platforms.linux;
  };
}
