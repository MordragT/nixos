{
  mordrag.hosts."tom-laptop" = {
    system = "x86_64-linux";
    stateVersion = "26.04";
    modules = [
      ./configuration.nix
      ./impermanence.nix
    ];

    homes.tom = ./homes/tom.nix;
  };
}
