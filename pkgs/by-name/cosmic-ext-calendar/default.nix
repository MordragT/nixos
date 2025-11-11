{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-calendar";
  version = "unstable-2025-10-01";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "calendar";
    rev = "96e2ce1d87254a73b6ac0eff99c80daaf66e78b7";
    hash = "sha256-H1u5z5fDLGIWOyVFgrjakBxHPvhITAByWV1I3YislAc=";
  };

  cargoHash = "sha256-7kkZaK1CRjvM2YUGk63uth+R8ivDJjHFohzVUfaE8N4=";

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
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-calendar"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A calendar application for the COSMIC desktop.";
    homepage = "https://github.com/cosmic-utils/calendar";
    # license = lib.licenses.gpl3Only; TODO not specified yet
    mainProgram = "cosmic-ext-calendar";
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.linux;
    broken = true; # requires cosmic accounts (broken too)
  };
}
