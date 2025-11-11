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
  version = "unstable-2025-10-25";

  src = fetchFromGitHub {
    owner = "hepp3n";
    repo = "kdeconnect";
    rev = "0eb739e52c4d3d383d0e1f3fbe2fcfaef2f01b19";
    hash = "sha256-mlUJ+ViRB8uz3MlJhjmiEIZoxVPpVDsMUlT3FM913eA=";
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
