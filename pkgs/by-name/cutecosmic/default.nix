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
  version = "unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "IgKh";
    repo = "cutecosmic";
    rev = "1469fa3a8890b74a7189d10de737150678b57418";
    hash = "sha256-40Ftca9MKDMNLO2lOV0yNi1bPzhGI6QIAZ4HOvbRHKY=";
  };

  patches = [
    ./cmake.patch
  ];

  cargoRoot = "bindings";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src cargoRoot;
    hash = "sha256-f8/ZgYMg9q6ClPHI70f609XJCooHsoaBR2l6SBQ4IyU=";
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
