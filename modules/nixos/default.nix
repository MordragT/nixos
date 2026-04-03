{
  flake.nixosModules.default = {
    imports = [
      ./boot
      ./desktop
      ./disks
      ./environment
      ./hardware
      ./platform
      ./programs
      ./secrets
      ./services
    ];
  };
}
