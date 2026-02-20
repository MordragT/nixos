{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.desktop.niri;
in
{
  options.mordrag.desktop.niri = {
    enable = lib.mkEnableOption "Niri";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.cosmic.enable = true;

    services.gnome.gnome-keyring.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    #programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      niri
      xwayland-satellite
      # cosmic-ext-alternative-startup
    ];
    services.displayManager.sessionPackages = with pkgs; [
      niri
      # cosmic-ext-niri
    ];

    systemd.packages = [ pkgs.niri ];

    #xdg.portal.enable = true;
    #xdg.portal.config.niri = {
    #  default = ["cosmic"];
    #  "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    #};
  };
}
