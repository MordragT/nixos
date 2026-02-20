{
  mordrag.hosts.installer = {
    system = "x86_64-linux";
    stateVersion = "25.11";
    modules = [
      ./configuration.nix
    ];

    homes.nixos = ./homes/nixos.nix;
  };
}
