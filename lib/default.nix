{inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
  my-lib = {
  };
  module = {
    _module.args = {inherit my-lib;};
  };
in {
  flake.nixosModules.default.imports = [module];
}
