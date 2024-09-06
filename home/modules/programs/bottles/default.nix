{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.bottles;
  wine = pkgs.wineWowPackages.stagingFull;
in {
  options.mordrag.programs.bottles = {
    enable = lib.mkEnableOption "Bottles";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.bottles];

    home.file.".local/share/bottles/runners/wine-system-${lib.getVersion wine}" = {
      source = wine;
      recursive = true;
      force = true;
    };

    home.file.".local/share/bottles/runners/wine-tkg-${lib.getVersion pkgs.wine-tkg}" = {
      source = pkgs.wine-tkg;
      recursive = true;
      force = true;
    };
  };
}
