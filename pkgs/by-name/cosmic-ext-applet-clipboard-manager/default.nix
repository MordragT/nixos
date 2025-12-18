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
  version = "unstable-2025-11-27";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = "4e509f5dd9513db58a699748314f388ed4664348";
    hash = "sha256-a96jEzbKlgScnFzbqs6ckpm8m19l4/mZt074GeOsUHI=";
  };

  cargoHash = "sha256-DmxrlYhxC1gh5ZoPwYqJcAPu70gzivFaZQ7hVMwz3aY=";

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

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Clipboard manager for COSMIC";
    homepage = "https://github.com/cosmic-utils/clipboard-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "cosmic-ext-applet-clipboard-manager";
  };
}
