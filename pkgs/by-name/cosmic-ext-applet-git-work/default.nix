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
  version = "unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "git-work";
    rev = "12854a17141e67ba460fbc6de24a433b1b22b389";
    hash = "sha256-v+cwvtjhgPsoFQPXgdAanSNCmqHJpZUhFXmgkdwiBqg=";
  };

  cargoHash = "sha256-BIA3Az8PqBM12mcEDEI2X/BflXF3wY8P18wN39AhIC8=";

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

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A GitHub notifications applet for the COSMIC desktop.";
    homepage = "https://github.com/cosmic-utils/git-work";
    # license = lib.licenses.gpl3Only; TODO none specified yet
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "git-work";
  };
}
