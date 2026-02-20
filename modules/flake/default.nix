{ inputs, ... }:
let
  flakeModules.default = {
    imports = [
      ./homes.nix
      ./hosts.nix
    ];
  };
in
{
  imports = [
    flakeModules.default
    inputs.flake-parts.flakeModules.flakeModules
  ];

  flake = {
    inherit flakeModules;
  };
}
