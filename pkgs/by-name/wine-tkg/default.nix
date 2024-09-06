{
  lib,
  wineWowPackages,
  fetchFromGitHub,
}:
lib.overrideDerivation wineWowPackages.unstableFull (old: rec {
  pname = "wine-tkg-full";
  version = "9.16";

  src = fetchFromGitHub {
    owner = "Kron4ek";
    repo = "wine-tkg";
    rev = version;
    hash = "sha256-dpW30hIGGw7zl6cmsY1wYHa7T+C4Si+b7s6/8QcHViE=";
  };
})
