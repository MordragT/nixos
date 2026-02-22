{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = with inputs; [
          # self.overlays.packages
          # self.overlays.legacyPackages
          # self.overlays.overrides
          comoji.overlays.default
          fenix.overlays.default
          nu-env.overlays.default
        ];

        config.allowUnfree = true;
      };
    };
}
