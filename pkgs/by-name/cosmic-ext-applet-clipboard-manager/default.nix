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
  version = "unstable-2025-11-05";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "clipboard-manager";
    rev = "f74b562a09e88e8d20ee0b9c5ab8cade8e4edbdb";
    hash = "sha256-tWNf0YZzVXM8FsA/jhGSrdPvnLRaVzQ1prYWINAGNN8=";
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
