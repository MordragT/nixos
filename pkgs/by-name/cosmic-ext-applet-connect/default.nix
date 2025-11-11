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
    repo = "cosmic-ext-applet-connect";
    rev = "a5e1d2b7bf79c3c972cc5109325c1f18a7f9d257";
    hash = "sha256-bN2MiTRVVAFd7ghr06z5wri+t3mL8hu82eQ4C4nFmGw=";
  };

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
    homepage = "https://github.com/hepp3n/cosmic-ext-applet-connect";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "cosmic-ext-applet-connect";
    broken = true; # Cargo.lock not included in git
  };
}
