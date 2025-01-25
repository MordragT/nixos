{
  self,
  nixpkgs,
  home-manager,
  templates,
}: {
  mkHost = {
    system,
    stateVersion,
    pkgs,
    imports ? [],
    modules ? [],
    specialArgs ? {},
    specialHomeArgs ? {},
    homes ? {},
  }:
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules =
        [
          {
            system.stateVersion = stateVersion;
            # nixpkgs.overlays = overlays;
            # nixpkgs.config.allowUnfree = true;
            nixpkgs.pkgs = pkgs;
            inherit imports;
          }
          home-manager.nixosModules.home-manager
          {
            # maybe ? https://github.com/nix-community/home-manager/issues/2701
            home-manager.useGlobalPkgs = true;
            # By default packages will be installed to $HOME/.nix-profile but they can be installed to /etc/profiles if
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialHomeArgs;
            home-manager.users = homes;
          }
        ]
        ++ modules;
    };

  mkHome = {
    username,
    homeDirectory ?
      if username == "root"
      then "/root"
      else "/home/${username}",
    stateVersion,
    imports ? [],
  }: {
    home = {
      inherit username stateVersion homeDirectory;
    };
    nix.registry = {
      self.flake = self;
      nixpkgs.flake = nixpkgs;
      templates.flake = templates;
    };
    inherit imports;
  };
}
