{
  mordrag.hosts."tom-server" = {
    system = "x86_64-linux";
    stateVersion = "24.05";
    modules = [
      ./boot.nix
      ./configuration.nix
      ./file-systems.nix
      ./impermanence.nix
      # ./kodi.nix
    ];

    homes.tom = ./homes/tom.nix;
  };
}
