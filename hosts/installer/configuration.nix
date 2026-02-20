{
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  mordrag.nix.enable = true;

  environment.systemPackages = with pkgs; [
    disko
    helix
  ];
}
