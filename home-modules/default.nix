{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.default = {
    imports = [
      ./core
      ./gnome
      ./programs
    ];
  };
}
