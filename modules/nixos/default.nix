{ inputs, ... }:
{
  flake.nixosModules.default = {
    imports = with inputs; [
      disko.nixosModules.default
      lanzaboote.nixosModules.default
      valhali.nixosModules.default
      ./desktop
      ./environment
      ./hardware
      ./programs
      ./secrets
      ./services
      ./bluetooth.nix
      ./boot.nix
      ./core.nix
      ./fonts.nix
      ./locale.nix
      ./networking.nix
      ./nix.nix
      ./pipewire.nix
      ./security.nix
      ./users.nix
      ./virtualisation.nix
      ./zram.nix
    ];
  };
}
