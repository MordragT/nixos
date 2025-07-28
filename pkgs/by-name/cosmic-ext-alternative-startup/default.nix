{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "cosmic-ext-alternative-startup";
  version = "unstable-2024-11-24";

  src = fetchFromGitHub {
    owner = "drakulix";
    repo = pname;
    rev = "8ceda00197c7ec0905cf1dccdc2d67d738e45417";
    hash = "sha256-0kqn3hZ58uQMl39XXF94yQS1EWmGIK45/JFTAigg/3M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DeMkAG2iINGden0Up013M9mWDN4QHrF+FXoNqpGB+mg=";

  meta = {
    description = "Provides an alternative entry point for cosmic-sessions compositor ipc interface.";
    homepage = "https://github.com/drakulix/cosmic-ext-alternative-startup";
    license = lib.licenses.gpl3Only;
    mainProgram = "cosmic-ext-alternative-startup";
    maintainers = [];
  };
}
