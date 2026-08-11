{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./amd-r5-2400g
    ./amd-r9-3900x
    ./intel-arc-a750
    ./intel-i7-13700h
    ./intel-n4100
  ];
}
