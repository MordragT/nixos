{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.bottles;
  wine = pkgs.wineWow64Packages.stagingFull;
  bottles = pkgs.bottles.override {
    removeWarningPopup = true;
  };
in
{
  options.mordrag.programs.bottles = {
    enable = lib.mkEnableOption "Bottles";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ bottles ];

    xdg.dataFile."bottles/runners/wine-system-${lib.getVersion wine}" = {
      source = wine;
      recursive = true;
      force = true;
    };
  };
}
