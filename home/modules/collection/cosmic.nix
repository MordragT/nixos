{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.collection.cosmic;
in {
  options.mordrag.collection.cosmic = {
    enable = lib.mkEnableOption "Cosmic";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cosmic-applet-emoji-selector
      cosmic-tasks
      cosmic-player
      cosmic-reader
      quick-webapps
      cosmic-calculator
      oboete
    ];
  };
}
