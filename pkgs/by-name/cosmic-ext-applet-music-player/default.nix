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
  pname = "cosmic-ext-applet-music-player";
  version = "unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "ebbo";
    repo = "cosmic-applet-music-player";
    rev = "1fe94a89a85be34b867ee94268e46e7fd72e88b8";
    hash = "sha256-GAIzV/BdU4SOV6P+qNGWmPzF5mvNym9D99/7Hg5/Amc=";
  };

  cargoHash = "sha256-Cs9g2w480jquSNyEG41WqOEMPQ/BJKcOgN8VnCfZBLQ=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-music-player"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    homepage = "https://github.com/Ebbo/cosmic-ext-applet-music-player";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "cosmic-ext-applet-music-player";
    broken = true; # libcosmic problem?
  };
}
