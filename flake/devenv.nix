{ inputs, ... }:
{
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem =
    {
      config,
      pkgs,
      inputs',
      system,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        shellHook = config.pre-commit.installationScript;
        packages = with pkgs; [
          nixfmt
          statix
          ssh-to-age
          rage
          unzip
          git
          inputs'.disko.packages.default
          inputs'.nixos-anywhere.packages.default
          # inputs'.vaultix.packages.default
        ];
      };

      pre-commit = {
        settings = {
          hooks = {
            nixfmt = {
              enable = true;
              id = "nixfmt";
              after = [ "statix" ];
            };
            statix = {
              enable = true;
              id = "statix";
            };
            yamllint = {
              enable = true;
              settings.configuration = ''
                rules:
                  truthy:
                    check-keys: false
              '';
            };
          };
        };
      };
    };
}
