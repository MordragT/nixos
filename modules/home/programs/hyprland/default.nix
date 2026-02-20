{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.programs.hyprland;
in {
  options.mordrag.programs.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
  };
}
