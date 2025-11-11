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
  pname = "cosmic-ext-accounts";
  version = "unstable-2025-10-01";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "accounts";
    rev = "eca21c7912041538748a46f54f322511d87030f1";
    hash = "sha256-8zxjBV69twMICH3HiDpTPU0pIYZuuCC6i9oByRo+YLk=";
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
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-accounts"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A library for COSMIC online account management.";
    homepage = "https://github.com/cosmic-utils/accounts";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-accounts";
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.linux;
    broken = true; # Cargo.lock not included in git
  };
}
