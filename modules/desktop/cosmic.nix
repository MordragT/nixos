{
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
  };
}
