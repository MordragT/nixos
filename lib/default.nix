{ lib, ... }:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "Library for flakes.";
  };

  config.flake.lib = {
    # TODO: fill with helpers
  };
}
