{modulesPath, ...}: {
  imports = [
    ../base
    ./boot.nix
    ./config.nix
    ./cosmic.nix
    ./file-systems.nix
    ./impermanence.nix
    # ./kodi.nix
    ./steam.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
}
