{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  just,
  openssl,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-accounts";
  version = "unstable-2025-11-11";

  src = fetchFromGitHub {
    owner = "mordragt";
    repo = "accounts";
    rev = "3e876332e9ba05838cc641c8f29a745b1da29d9e";
    hash = "sha256-yj786cPIByHKiozq8jJkTC14LHf5Zv/PT4jYUOGk50w=";
  };

  cargoHash = "sha256-XnJnFlC4Ws8AYZ60a6CZ577FGj5viTLKFqzAZSCJvEY=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  buildInputs = [
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin1-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/accounts-daemon"
    "--set"
    "bin2-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/accounts-ui"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A library for COSMIC online account management.";
    homepage = "https://github.com/cosmic-utils/accounts";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-accounts";
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.linux;
    broken = true;
  };
}
