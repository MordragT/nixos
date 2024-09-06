{modulesPath, ...}: {
  imports = [
    ../base
    ./boot.nix
    ./config.nix
    ./file-systems.nix
    ./impermanence.nix
    ./programs.nix
    ./services.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
}
