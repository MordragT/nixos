{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  openssl,
  dbus,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-music-player";
  version = "unstable-2025-11-11";

  src = fetchFromGitHub {
    owner = "mordragt";
    repo = "cosmic-applet-music-player";
    rev = "ccdae7c068770498e4abffdc807cebce2cc1fd91";
    hash = "sha256-LWnC2CQv/0YVeVIz7VUnqqDLdB9DOJmwa9tDWEi1jwQ=";
  };

  cargoHash = "sha256-ujV43a5mbPeyKDrAoPyJ/1H0YsUM3dJWIezp0mdSzf0=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    openssl
    dbus.dev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-music-player"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Ebbo/cosmic-ext-applet-music-player";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "cosmic-ext-applet-music-player";
  };
}
