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
  pname = "cosmic-ext-applet-gamemode-status";
  version = "unstable-2025-11-10";

  src = fetchFromGitHub {
    owner = "mordragt";
    repo = "cosmic-ext-applet-gamemode-status";
    # rev = "v${version}";
    rev = "0bf9518112d3e5af5a4b65dd24758ebea926b714";
    hash = "sha256-QspiYxWVOW6pMs64bWrxxWQVfGp8hFNHBFtQwTPjzQs=";
  };

  cargoHash = "sha256-We02sFKIbsGh3l+YNMw0EPQLcsgU+Vn55BY5bocCUgk=";

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
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-gamemode-status"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    homepage = "https://github.com/d-brox/cosmic-ext-applet-gamemode-status";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "cosmic-ext-applet-gamemode-status";
  };
}
