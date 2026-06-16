{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-applet-logomoenu";
  version = "0.6.11";

  src = fetchFromGitHub {
    owner = "cappsyco";
    repo = "cosmic-ext-applet-logomenu";
    rev = "v${version}";
    hash = "sha256-WIS7fibkWcUcEfG9/DyNzxWbhpD3HKqqy+6lOqVwyc8=";
  };

  cargoHash = "sha256-jbxPlH8S9Xm9Hm+y3Ac21T1jRy6kBr58LKiylJ6jZnU=";

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
    "bin-src1"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-logomenu"
    "--set"
    "bin-src2"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-logomenu-settings"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch=HEAD"
    ];
  };

  meta = {
    homepage = "https://github.com/cappsyco/cosmic-ext-applet-logomenu";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "cosmic-ext-applet-logomenu";
  };
}
