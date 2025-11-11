{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
  pipewire,
  pkg-config,
  glib,
  libclang,
}:
rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-privacy-indicator";
  version = "unstable-2025-07-03";

  src = fetchFromGitHub {
    owner = "d-brox";
    repo = "cosmic-ext-applet-privacy-indicator";
    rev = "2d3b0efec5a95cf704e414f6e3005641f3aa3666";
    hash = "sha256-iTdCn5IbOs+g9MeC+EDUGSYxlHTrmhouvL7Y6Y3rK/M=";
  };

  cargoHash = "sha256-Tbcjnbjyo+FoYtRe5KnPiEzV+1PkzHOnbVDRe/pJul0=";

  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = [
    "-I${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${stdenv.cc.cc.version}/include"
    "-I${stdenv.cc.libc.dev}/include"
  ];

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];

  buildInputs = [
    pipewire
    glib
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-privacy-indicator"
  ];

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A COSMIC applet for indicating and controlling camera and microphone usage";
    homepage = "https://github.com/d-brox/cosmic-ext-applet-privacy-indicator";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
    mainProgram = "cosmic-ext-applet-privacy-indicator";
  };
}
