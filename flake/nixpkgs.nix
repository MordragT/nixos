{inputs, ...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = with inputs; [
        self.overlays.default
        comoji.overlays.default
        fenix.overlays.default
        nu-env.overlays.default
      ];

      config.allowUnfree = true;
    };
  };
}
