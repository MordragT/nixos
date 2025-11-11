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
  pname = "cosmic-ext-applet-tailscale";
  version = "unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = "644618bd21b12b7f1383692fb58ba0c6bfc0eef6";
    hash = "sha256-AK2//YkHR+rkAnDMuk6s1oQxCSVZe8v2xhsU7fnDYEE=";
  };

  cargoHash = "sha256-ND5+KAMrSFRHXI2SXmfOqhTDg+mPhU+x3lh5pKyFrPQ=";

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

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A COSMIC applet for managing tailscale VPN connections";
    homepage = "https://github.com/cosmic-utils/gui-scale-applet";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "gui-scale-applet";
  };
}
