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
    services.desktopManager.cosmic.enable = true;

    services.gnome.gnome-keyring.enable = true;
    # services.gnome.gnome-online-accounts.enable = true;
    # services.accounts-daemon.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.systemPackages = with pkgs; [
      cosmic-ext-applet-caffeine
      # cosmic-ext-applet-clipboard-manager # requires unsafe environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
      # cosmic-ext-applet-connect
      cosmic-ext-applet-external-monitor-brightness
      cosmic-ext-applet-emoji-selector
      cosmic-ext-applet-gamemode-status
      cosmic-ext-applet-git-work
      cosmic-ext-applet-logomenu
      cosmic-ext-applet-minimon
      # cosmic-ext-applet-music-player
      cosmic-ext-applet-privacy-indicator
      cosmic-ext-applet-system-monitor
      # cosmic-ext-applet-tailscale
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
      # observatory
      oboete
      # quick-webapps
      # starrydex
      # stellarshot
      tasks
    ];

    # required for observatory to work
    # systemd.packages = [pkgs.observatory];
    # systemd.services.monitord.wantedBy = ["multi-user.target"];
  };
}
