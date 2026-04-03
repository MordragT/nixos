{
  lib,
  config,
  inputs,
  self,
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
                description = "NixOS state version to be used for this host.";
                type = str;
              };

              domain = lib.mkOption {
                description = "Domain of the host";
                type = str;
                default = "mordrag.de";
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

  imports = [
    ./desktop
    ./installer
    ./laptop
    ./server
  ];

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

        specialArgs = {
          inherit inputs self;
        };

        modules =
          with inputs;
          [
            config.flake.nixosModules.default
            # TODO only import of home-manager option is enabled ??
            home-manager.nixosModules.default
            {
              system = { inherit (host) stateVersion; };
              networking = {
                inherit hostName;
                inherit (host) domain;
              };
              nixpkgs = {
                config.allowUnfree = true;
                overlays = [ config.flake.overlays.default ];
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit inputs self;
                };
                users = lib.mapAttrs (
                  username: module:
                  let
                    homeDirectory = if username == "root" then "/root" else "/home/${username}";
                  in
                  {
                    imports = [
                      module
                      self.homeModules.default
                      {
                        home = {
                          inherit (host) stateVersion;
                          inherit username homeDirectory;
                        };

                        nix.registry = {
                          self.flake = self;
                          nixpkgs.flake = nixpkgs;
                          templates.flake = templates;
                        };
                      }
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
