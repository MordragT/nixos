{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.desktop.cosmic;
in {
  options.mordrag.desktop.cosmic = {
    enable = lib.mkEnableOption "Cosmic";
  };

  config = lib.mkIf cfg.enable {
    # mordrag.services.cosmic-bg-theme.enable = true;

    services.desktopManager.cosmic.enable = true;

    services.gnome.gnome-keyring.enable = true;
    # services.gnome.gnome-online-accounts.enable = true;
    # services.accounts-daemon.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      COSMIC_DATA_CONTROL_ENABLED = "1"; # needed for cosmic-ext-applet-clipboard-manager
    };

    environment.systemPackages = with pkgs; [
      cosmic-ext-applet-caffeine
      cosmic-ext-applet-clipboard-manager
      # cosmic-ext-applet-connect
      # cosmic-ext-applet-external-monitor-brightness
      # cosmic-ext-applet-emoji-selector
      cosmic-ext-applet-gamemode-status
      # cosmic-ext-applet-git-work
      cosmic-ext-applet-logomenu
      cosmic-ext-applet-minimon
      cosmic-ext-applet-music-player
      cosmic-ext-applet-privacy-indicator
      # cosmic-ext-applet-system-monitor
      cosmic-ext-applet-tailscale
      cosmic-ext-applet-weather

      # cosmic-ext-accounts
      # cosmic-ext-calendar
      cosmic-ext-calculator
      cosmic-ext-tweaks

      cosmic-player
      cosmic-reader

      # andromeda
      # chronos
      examine
      fan-control
      forecast
      oboete
      # quick-webapps
      # starrydex
      # stellarshot
      tasks
    ];
  };
}
