{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.cosmic;
in {
  options = {
    desktop.cosmic = {
      enable = lib.mkEnableOption "Cosmic";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;

    environment.systemPackages = with pkgs.gnome; [
      nautilus
      gnome-system-monitor
      gnome-calendar
      gnome-calculator
      simple-scan
    ];

    programs.evince.enable = true;
    programs.file-roller.enable = true;
    programs.geary.enable = true;

    services.udisks2.enable = true;
    programs.gnome-disks.enable = true;

    # quick previewer for nautilus
    services.gnome.sushi.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;
    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
