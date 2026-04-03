{
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
          nixos-install-tools
          ssh-to-age
          rage
          inputs'.disko.packages.default
          inputs'.nixos-anywhere.packages.default
        ];
      };
    };
}
