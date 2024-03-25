{modulesPath, ...}: {
  imports = [
    ./boot.nix
    ./config.nix
    ./file-systems.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
}
