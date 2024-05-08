{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.hyprland;
in {
  options = {
    desktop.hyprland = {
      enable = lib.mkEnableOption "Hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;

    xdg.portal.configPackages = [
      (pkgs.writeTextDir "share/xdg-desktop-portal/hyprland-portals.conf" ''
        [preferred]
        default=gtk;hyprland
      '')
    ];
  };
}
