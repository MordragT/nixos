{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.desktop.hyprland;
in {
  options.mordrag.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;

    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    programs.hyprland.enable = true;

    #xdg.portal.enable = true;
    #xdg.portal.config.hyprland = {
    #  default = [
    #    "hyprland"
    #    "cosmic"
    #  ];
    #  "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    #};
  };
}
