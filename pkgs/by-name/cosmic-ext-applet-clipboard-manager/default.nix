{
  fetchFromGitHub,
  lib,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-applet-clipboard-manager";
  version = "unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = "d8840236acbaf3679acd7c4b10102b86e7da27f6";
    hash = "sha256-GTSz0NRRImdweLx0PdgrwJ/iL5ujeyysbxAuHlX5AUQ=";
  };

  cargoHash = "sha256-0CziruLYJrku1FO7tBSJRNtS5JyhjDWxTEcOwUVYmSk=";

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
    "CLIPBOARD_MANAGER_COMMIT"
    "${src.rev}"
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-clipboard-manager"
  ];

  # env.CLIPBOARD_MANAGER_COMMIT = src.rev;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clipboard manager for COSMIC";
    homepage = "https://github.com/cosmic-utils/clipboard-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "cosmic-ext-applet-clipboard-manager";
  };
}
