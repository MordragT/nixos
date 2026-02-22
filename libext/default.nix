{ lib, ... }:
let
  libext = {
  };
  module = {
    _module.args = {
      inherit libext;
    };
  };
in
{
  flake = {
    inherit libext;
    nixosModules.default.imports = [ module ];
  };

  perSystem = {
    imports = [ module ];
  };
}
