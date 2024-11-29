{modulesPath, ...}: {
  imports = [
    ../base
    ./boot.nix
    ./config.nix
    ./cosmic.nix
    ./file-systems.nix
    ./impermanence.nix
    ./kodi.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
}
