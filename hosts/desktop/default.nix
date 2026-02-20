{
  mordrag.hosts."tom-desktop" = {
    system = "x86_64-linux";
    stateVersion = "23.11";
    modules = [
      ./configuration.nix
      ./file-systems.nix
      ./impermanence.nix
      ./programs.nix
      ./services.nix
    ];

    homes.tom = ./homes/tom.nix;
  };
}
