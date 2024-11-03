{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.desktop.gnome;
in {
  options.mordrag.desktop.gnome = {
    enable = lib.mkEnableOption "Gnome";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs.gnomeExtensions; [
      space-bar
      task-widget
      # broken valent
      fly-pie
    ];
  };
}
