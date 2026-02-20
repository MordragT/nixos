{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.default = {
    imports = [
      ./collection
      ./core
      ./programs
      ./services
    ];
  };
}
