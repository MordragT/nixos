{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./amd-r5-2600.nix
    ./intel-arc-a750.nix
    ./intel-i7-1260p.nix
    ./intel-n4100.nix
  ];
}
