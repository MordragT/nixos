{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cargo,
  rustPlatform,
  qt6,
  corrosion,
  rustc,
}:
stdenv.mkDerivation rec {
  pname = "cutecosmic";
  version = "unstable-2026-01-21";

  src = fetchFromGitHub {
    owner = "IgKh";
    repo = "cutecosmic";
    rev = "8e584418f69eeeaee8574c4a48cc92ef27fd610e";
    hash = "sha256-jKiO+WlNHM1xavKdB6PrGd3HmTgnyL1vjh0Ps1HcWx4=";
  };

  patches = [
    ./cmake.patch
  ];

  cargoRoot = "bindings";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-+1z0VoxDeOYSmb7BoFSdrwrfo1mmwkxeuEGP+CGFc8Y=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cmake
    pkg-config
  ];

  buildInputs = [
    corrosion
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwebengine
  ];

  cmakeFlags = [
    "-DQT_INSTALL_PLUGINS=${qt6.qtbase.qtPluginPrefix}"
  ];

  meta = with lib; {
    description = "Qt platform theme plugin for the COSMIC desktop environment";
    homepage = "https://github.com/IgKh/cutecosmic";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
