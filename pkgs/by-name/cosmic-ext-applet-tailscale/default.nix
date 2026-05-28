{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:
let
  version = "3.10.1";
in
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-tailscale";
  inherit version;

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = version;
    hash = "sha256-jePK1NTDoPvQ2G/YcDk60cttbNPaQSNSH7/PMU0BFD4=";
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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/gui-scale-applet"
  ];

  postPatch = ''
    substituteInPlace justfile \
        --replace-fail "sudo install" "install"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A COSMIC applet for managing tailscale VPN connections";
    homepage = "https://github.com/cosmic-utils/gui-scale-applet";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "gui-scale-applet";
  };
}
