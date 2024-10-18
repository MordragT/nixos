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
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;
    # services.gnome.gnome-online-accounts.enable = true;
    # services.accounts-daemon.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      cosmic-ext-applet-clipboard-manager
      cosmic-ext-applet-emoji-selector
      cosmic-ext-calculator
      cosmic-ext-examine
      cosmic-ext-forecast
      cosmic-ext-tasks
      cosmic-ext-tweaks
      cosmic-player
      cosmic-reader
      chronos
      oboete
      quick-webapps
      stellarshot
    ];
  };
}
