{
  lib,
  fetchFromGitHub,
  rustPlatform,
  fetchNpmDeps,
  cargo-tauri,
  glib-networking,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "trellis-studio";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "pwilkin";
    repo = "trellis.cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eahL/TTzELvT7IohJNVTpy96+oajGeWMAcHY16YsO4s=";
    fetchSubmodules = true;
  };
  sourceRoot = "source/app";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-GkRMXRzGK6XNtlU20z6QeQQQcjpzvgqLgxNh7sH4dQ8=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src sourceRoot;
    hash = "sha256-MUqHVk3vpHz+IfKeqrK/yvWIBS5XCIGyOeMC4wVeujc=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  meta = with lib; {
    description = "Trellis Studio desktop app";
    homepage = "https://github.com/pwilkin/trellis.cpp";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "trellis-studio";
  };
})
