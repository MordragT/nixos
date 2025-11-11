{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  pkgs,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-applet-system-monitor";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "d-brox";
    repo = "cosmic-ext-applet-system-monitor";
    rev = "v${version}";
    hash = "sha256-L1XkRgsTvaMFPn5a4+rSNj13x9jXx6eeWssICp0Rqco=";
  };

  cargoHash = "sha256-yiBaP5USaQJFpMuJZyXjDEZeZuBUY+3viV9hfccdoJc=";

  nativeBuildInputs = with pkgs; [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = with pkgs; [fontconfig];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-system-monitor"
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR="$TMP"
  '';

  passthru.updateScript = nix-update-script {};

  meta = {
    homepage = "https://github.com/D-Brox/cosmic-ext-applet-system-monitor";
    description = "Highly configurable system resource monitor for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-system-monitor";
  };
}
