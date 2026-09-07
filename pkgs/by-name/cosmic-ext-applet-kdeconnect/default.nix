{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  nix-update-script,
}:
let
  version = "0.10.0";
in
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-kdeconnect";
  inherit version;

  src = fetchFromGitHub {
    owner = "hepp3n";
    repo = "kdeconnect";
    rev = "v${version}";
    hash = "";
  };

  cargoHash = "";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/kdeconnect";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "kdeconnect-service";
    broken = true;
  };
}
