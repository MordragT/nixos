{
  mordrag.hosts."tom-server" = {
    system = "x86_64-linux";
    stateVersion = "24.05";
    modules = [
      ./configuration.nix
      ./file-systems.nix
      ./impermanence.nix
    ];

    homes.tom = ./homes/tom.nix;
  };
}
