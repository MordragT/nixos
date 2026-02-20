{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./amd-r5-2600.nix
    ./intel-arc-a750.nix
    ./intel-n4100.nix
  ];
}
