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
  version = "unstable-2025-11-30";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = "9528f588d7a010149071136ea3f9948771f7d0cf";
    hash = "sha256-/oTU+FF10YhgadIG61M8R9LQUV3kkcLczlbV9/53D7I=";
  };

  cargoHash = "sha256-G0YJifAC+/cl9l592vDGmVDsMwG6VyJLfw0abc/3PKk=";

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
