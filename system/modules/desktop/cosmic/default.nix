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

    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    # services.gnome.gnome-online-accounts.enable = true;
    # services.accounts-daemon.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      # andromeda
      # cosmic-ext-applet-caffeine
      # cosmic-ext-applet-clipboard-manager # requires unsafe environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
      # cosmic-ext-applet-emoji-selector
      cosmic-ext-calculator
      cosmic-ext-tweaks
      cosmic-player
      # cosmic-reader
      # chronos
      # examine
      forecast
      # observatory
      oboete
      # quick-webapps
      # stellarshot
      tasks
    ];

    # required for observatory to work
    # systemd.packages = [pkgs.observatory];
    # systemd.services.monitord.wantedBy = ["multi-user.target"];
  };
}
