{
  nixpkgs,
  pkgs,
  home-manager,
}: {
  mkHost = {
    system,
    stateVersion,
    modules,
    specialArgs ? {},
    specialHomeArgs ? {},
    homes,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules =
        [
          {
            boot.supportedFilesystems = ["ntfs"];

            system.stateVersion = stateVersion;

            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            boot.tmp.useTmpfs = true;
            boot.tmp.tmpfsSize = "75%";
            boot.tmp.cleanOnBoot = true;
            boot.runSize = "25%";
            boot.kernelPackages = pkgs.linuxPackages_cachyos-lto; #linuxPackages_latest/testing/6_7
          }
          home-manager.nixosModules.home-manager
          {
            # maybe ? https://github.com/nix-community/home-manager/issues/2701
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialHomeArgs;
            home-manager.users = homes;
          }
        ]
        ++ modules;

      # config._modules.args = { inherit pkgs; };
    };

  mkHome = {
    username,
    homeDirectory ? "/home/${username}",
    stateVersion,
    imports,
  }: {
    "${username}" = {
      home = {
        inherit username stateVersion homeDirectory;
      };
      xdg = {
        enable = true;
        userDirs.enable = true;
        # configHome = "~/.config";
        # cacheHome = "/run/user/1000/.cache";
        # dataHome = "~/.local/share";
        # stateHome = "~/.local/state";
      };
      nix.registry.nixpkgs.flake = nixpkgs;
      inherit imports;
    };
  };
}
