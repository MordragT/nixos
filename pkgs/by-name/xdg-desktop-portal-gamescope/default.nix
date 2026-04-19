{
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  rustPlatform,
  systemd,
  dbus,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-gamescope";
  version = "0.1.33.412a4bf";

  src = fetchFromGitHub {
    owner = "evlaV";
    repo = "xdg-desktop-portal-gamescope";
    rev = "412a4bff892bdb5726a549d03b11e6ce2f8e8152";
    hash = "sha256-WmovgfLZQwa+a04FiAlNDwom/xDl8VURn/gmMit8Nvk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-yh/sTiSgzuVJZquMrDheMAHcE7kczOx/v14AHuAYBOs=";
  };

  env.PKG_CONFIG_DBUS_1_SESSION_BUS_SERVICES_DIR = "${placeholder "out"}/share/dbus-1/services";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustc
    cargo
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    systemd
    dbus
  ];
})
