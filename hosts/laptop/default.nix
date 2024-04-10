{modulesPath, ...}: {
  imports = [
    ./boot.nix
    ./config.nix
    ./file-systems.nix
    ./impermanence.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
}
