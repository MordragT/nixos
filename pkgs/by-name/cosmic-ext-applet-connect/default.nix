{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-connect";
  version = "unstable-2025-11-25";

  src = fetchFromGitHub {
    owner = "hepp3n";
    repo = "kdeconnect";
    rev = "18791fe1fff3e5b66dc4f1fd6cbdda6c6a802595";
    hash = "";
  };
  sourceDir = "source/cosmic-ext-applet-connect";

  cargoHash = "";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-connect"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    homepage = "https://github.com/hepp3n/kdeconnect";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "cosmic-ext-applet-connect";
    broken = true;
  };
}
