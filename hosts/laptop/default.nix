{
  mordrag.hosts."tom-laptop" = {
    system = "x86_64-linux";
    stateVersion = "26.05";
    modules = [
      ./configuration.nix
    ];

    homes.tom = ./homes/tom.nix;
  };
}
