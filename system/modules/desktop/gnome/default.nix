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
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      totem
      evince
      gnome-color-manager
    ];

    environment.systemPackages = with pkgs;
      [
        showtime
        papers
      ]
      ++ (with pkgs.gnomeExtensions; [
        space-bar
        task-widget
        # broken valent
        fly-pie
      ]);
  };
}
