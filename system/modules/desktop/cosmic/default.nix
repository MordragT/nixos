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
      andromeda
      cosmic-ext-applet-clipboard-manager
      cosmic-ext-applet-emoji-selector
      cosmic-ext-calculator
      cosmic-ext-tweaks
      cosmic-player
      cosmic-reader
      chronos
      examine
      forecast
      oboete
      quick-webapps
      stellarshot
      tasks
    ];
  };
}
