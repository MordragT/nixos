{
  flake.nixosModules.default = {
    imports = [
      ./boot
      ./containers
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
