{inputs, ...}: {
  flake.nixosModules.default = {
    imports = with inputs; [
      disko.nixosModules.default
      lanzaboote.nixosModules.default
      valhali.nixosModules.default
      ./desktop
      ./environment
      ./programs
      ./secrets
      ./services
      ./bluetooth.nix
      ./core.nix
      ./fonts.nix
      ./locale.nix
      ./networking.nix
      ./nix.nix
      ./pipewire.nix
      ./security.nix
      ./users.nix
      ./virtualisation.nix
    ];
  };
}
