{
  lib,
  config,
  inputs,
  withSystem,
  ...
}:
{
  options.mordrag.hosts = lib.mkOption {
    type =
      with lib.types;
      attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                type = str;
                default = name;
                readOnly = true;
              };

              system = lib.mkOption {
                type = str;
                default = "x86_64-linux";
              };

              stateVersion = lib.mkOption {
                type = str;
              };

              modules = lib.mkOption {
                type = listOf deferredModule;
                default = { };
              };

              homes = lib.mkOption {
                type = lazyAttrsOf deferredModule;
              };
            };
          }
        )
      );
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    hostName: host:
    withSystem host.system (
      {
        pkgs,
        system,
        ...
      }:
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;

        modules =
          with inputs;
          [
            config.flake.nixosModules.default
            # TODO: This is sadly necessary as classified doesn't follow conventions
            # It would be great if this could just be added to the nixpkgs overlay instead
            classified.nixosModules.${system}.default
            # TODO only import of home-manager option is enabled ??
            home-manager.nixosModules.default
            {
              system = { inherit (host) stateVersion; };
              networking = { inherit hostName; };
              nixpkgs = {
                inherit pkgs;
                overlays = [ config.flake.overlays.default ];
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = lib.mapAttrs (
                  username: module:
                  let
                    homeDirectory = if username == "root" then "/root" else "/home/${username}";
                  in
                  _: {
                    imports = [
                      module
                      self.homeModules.default
                      (_: {
                        home = {
                          inherit (host) stateVersion;
                          inherit username homeDirectory;
                        };

                        nix.registry = {
                          self.flake = self;
                          nixpkgs.flake = nixpkgs;
                          templates.flake = templates;
                        };
                      })
                    ];
                  }
                ) host.homes;
              };
            }
          ]
          ++ host.modules;
      }
    )
  ) config.mordrag.hosts;
}
