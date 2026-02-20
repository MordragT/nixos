{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.desktop.labwc;
in {
  options.mordrag.desktop.labwc = {
    enable = lib.mkEnableOption "labwc";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;

    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.labwc.enable = true;

    #environment.systemPackages = [pkgs.labwc];
    #services.displayManager.sessionPackages = [pkgs.labwc];

    #xdg.portal.enable = true;
    #xdg.portal.config.wlroots = {
    #  default = [
    #    "wlr"
    #    "cosmic"
    #  ];
    #  "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    #};
  };
}
