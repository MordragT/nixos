{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
}:
let
  version = "0.3.7";
in
rustPlatform.buildRustPackage {
  pname = "starrydex";
  inherit version;

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "starrydex";
    rev = version;
    hash = "";
  };

  cargoHash = "";

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  meta = {
    description = "A Pokédex application for the COSMIC™ desktop written in Rust ";
    homepage = "https://github.com/mariinkys/starrydex";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "starry-dex";
    platforms = lib.platforms.linux;
  };
}
