{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./amd-r5-2400g
    ./amd-r5-2600
    ./intel-arc-a750
    ./intel-i7-1260p
    ./intel-n4100
  ];
}
