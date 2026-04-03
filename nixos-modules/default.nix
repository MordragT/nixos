{
  flake.nixosModules.default = {
    imports = [
      ./boot
      ./desktop
      ./disks
      ./hardware
      ./networking
      ./platform
      ./programs
      ./services
      ./state
      ./users
    ];
  };
}
