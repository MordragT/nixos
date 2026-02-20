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
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
      systemPackages = with pkgs; [
        niri
        xwayland-satellite
        # cosmic-ext-alternative-startup
      ];
    };

    services = {
      desktopManager = {
        cosmic.enable = true;
      };
      displayManager = {
        sessionPackages = with pkgs; [
          niri
          # cosmic-ext-niri
        ];
      };
      gnome = {
        gnome-keyring.enable = true;
      };
    };

    systemd.packages = [ pkgs.niri ];

    #programs.niri.enable = true;

    #xdg.portal = {
    #  enable = true;
    #  config.niri = {
    #    default = ["cosmic"];
    #    "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    #  };
    #};
  };
}
