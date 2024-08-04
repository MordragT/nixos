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
      cosmic-emoji-picker
      cosmic-tasks
      oboete
    ];
  };
}
