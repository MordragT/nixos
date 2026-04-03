{ inputs, ... }:
let
  flakeModules.default = {
    imports = [
      ./homes
      ./hosts
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
