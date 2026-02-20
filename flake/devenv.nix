{inputs, ...}: {
  imports = [
    inputs.git-hooks.flakeModule
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      shellHook = config.pre-commit.installationScript;
      packages = with pkgs; [
        nixfmt
        statix
        disko
        unzip
        git
      ];
    };

    pre-commit = {
      settings = {
        hooks = {
          nixfmt = {
            enable = true;
            id = "nixfmt";
            after = ["statix"];
          };
          statix = {
            enable = true;
            id = "statix";
          };
        };
      };
    };
  };
}
