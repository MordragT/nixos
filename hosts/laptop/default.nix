{
  mordrag.hosts."tom-laptop" = {
    system = "x86_64-linux";
    stateVersion = "23.11";
    modules = [
      ./configuration.nix
      ./file-systems.nix
      ./impermanence.nix
    ];

    homes.tom = ./homes/tom.nix;
  };
}
