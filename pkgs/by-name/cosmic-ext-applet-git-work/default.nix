{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  git,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-applet-git-work";
  version = "unstable-2026-02-12";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "git-work";
    rev = "5421ee3a57da47f96f601ed7ae0e93a331218dff";
    hash = "";
  };

  cargoHash = "";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    git
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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/git-work"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A GitHub notifications applet for the COSMIC desktop.";
    homepage = "https://github.com/cosmic-utils/git-work";
    # license = lib.licenses.gpl3Only; TODO none specified yet
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "git-work";
  };
}
