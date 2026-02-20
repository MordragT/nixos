{
  lib,
  config,
  inputs,
  withSystem,
  ...
}: {
  options.mordrag.homes = lib.mkOption {
    type = with lib.types;
      attrsOf (submodule ({name, ...}: {
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

          module = lib.mkOption {
            type = deferredModule;
            default = {};
          };
        };
      }));
  };

  config.flake.homeConfigurations = lib.mapAttrs (_name: home:
    withSystem home.system ({
      pkgs,
      system,
      ...
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          home.module
          inputs.self.homeModules.default
        ];
      }))
  config.mordrag.homes;
}
