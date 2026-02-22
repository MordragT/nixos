{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "starrydex";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mariinkys";
    repo = "starrydex";
    rev = version;
    hash = "sha256-2iABIJaWtxTdaLXh+Jvj7pI3SxEJ9JKbGoiU7MuiP0E=";
  };

  cargoHash = "sha256-x2igZLo4tGdKfn8ViyLlBqJJp4NdISX5y+M4VpnVipE=";

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  buildInputs = [
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
