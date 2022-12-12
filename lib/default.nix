{ nixpkgs, pkgs, home-manager, agenix }:
{
  mkHost =
    { system
    , stateVersion
    , modules
    , specialArgs ? { }
    , specialHomeArgs ? { }
    , users
    , homes
    }:
    let
      config = pkgs.config;
      lib = pkgs.lib;
    in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;

      modules = [
        {
          boot.supportedFilesystems = [ "ntfs" ];

          inherit users;
          system.stateVersion = stateVersion;

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          # league of legends
          boot.kernel.sysctl."abi.vsyscall32" = 0;

          hardware.opengl.enable = true;
        }
        home-manager.nixosModules.home-manager
        {
          # maybe ? https://github.com/nix-community/home-manager/issues/2701
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialHomeArgs;
          home-manager.users = homes;
        }
        agenix.nixosModules.age
      ] ++ modules;

      # config._modules.args = { inherit pkgs; };
    };

  mkHome =
    { username
    , homeDirectory ? "/home/${username}"
    , stateVersion
    , packages
    , imports
    }:
    {
      "${username}" = {
        inherit imports;
        # fix for "useGlobalPkgs"
        #nixpkgs = { inherit (pkgs) config overlays; };

        home = {
          inherit username stateVersion packages homeDirectory;
        };
        xdg = {
          enable = true;
          userDirs.enable = true;
        };

        pam.sessionVariables = {
          XDG_CONFIG_HOME = "/home/${username}/.config";
          XDG_CACHE_HOME = "/home/${username}/.cache";
          XDG_DATA_HOME = "/home/${username}/.local/share";
          XDG_STATE_HOME = "/home/${username}/.local/state";
          XDG_DATA_DIRS = "/usr/share:/usr/local/share:/home/${username}/.local/share/:/home/${username}/.nix-profile/share";
        };
      };
    };
}
