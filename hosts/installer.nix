{
  pkgs,
  modulesPath,
  ...
}: {
  imports = ["${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];

  environment.systemPackages = with pkgs; [
    disko
    helix
  ];
}
