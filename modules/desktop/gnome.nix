{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.gnome;
in {
  options = {
    desktop.gnome = {
      enable = lib.mkEnableOption "Gnome";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      xkb.layout = "de";
      displayManager.gdm = {
        enable = true;
        wayland = true;
        banner = ''
          Valve please fix
        '';
      };
      desktopManager.gnome.enable = true;
    };

    environment.systemPackages = with pkgs.gnomeExtensions; [
      space-bar
      rounded-window-corners
      task-widget
      valent
      fly-pie
    ];
  };
}
