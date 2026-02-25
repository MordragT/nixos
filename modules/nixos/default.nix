_: {
  flake.nixosModules.default = {
    imports = [
      ./desktop
      ./environment
      ./hardware
      ./programs
      ./secrets
      ./services
      ./bluetooth.nix
      ./boot.nix
      ./core.nix
      ./disks.nix
      ./fonts.nix
      ./locale.nix
      ./networking.nix
      ./nix.nix
      ./pipewire.nix
      ./platform.nix
      ./security.nix
      ./users.nix
      ./virtualisation.nix
      ./zram.nix
    ];
  };
}
