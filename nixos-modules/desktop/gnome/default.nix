{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.desktop.gnome;
in
{
  options.mordrag.desktop.gnome = {
    enable = lib.mkEnableOption "Gnome";
    gdm = lib.mkEnableOption "GDM Display Manager";
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = cfg.gdm;
    };

    environment.gnome.excludePackages = with pkgs; [
      totem
      evince
      gnome-color-manager
    ];

    environment.systemPackages =
      with pkgs;
      [
        showtime
        papers
      ]
      ++ (with pkgs.gnomeExtensions; [
        space-bar
        task-widget
        valent
        fly-pie
      ]);
  };
}
