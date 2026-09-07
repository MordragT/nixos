{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  nix-update-script,
}:
let
  version = "3.10.2";
in
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-tailscale";
  inherit version;

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = version;
    hash = "";
  };

  cargoHash = "";

  nativeBuildInputs = [ libcosmicAppHook ];

  postInstall = ''
    install -Dm0644 data/com.github.bhh32.GUIScaleApplet.desktop $out/share/applications/
    install -Dm0644 data/icons/scalable/apps/tailscale-icon.png $out/share/icons/hicolor/scalable/status/
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
