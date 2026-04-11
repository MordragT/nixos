{ inputs, ... }:
{
  mordrag.hosts."tom-desktop" = {
    system = "x86_64-linux";
    stateVersion = "23.11";
    modules = [
      inputs.qpad.nixosModules.default
      inputs.vaultix.nixosModules.default
      ./configuration.nix
      ./file-systems.nix
      ./programs.nix
      ./services.nix
    ];

    homes.tom = ./homes/tom.nix;
  };
}
