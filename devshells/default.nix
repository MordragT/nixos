{
  perSystem =
    {
      config,
      pkgs,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        shellHook = config.pre-commit.installationScript;
        packages = with pkgs; [
          prek
          nixfmt
          statix
          unzip
          nixos-install-tools
          ssh-to-age
          rage
          nushell
          inputs'.disko.packages.default
          inputs'.nixos-anywhere.packages.default
        ];
      };
    };
}
