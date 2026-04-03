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
      sessionVariables.NIXOS_OZONE_WL = "1";

      systemPackages = with pkgs; [
        niri
        xwayland-satellite
      ];

      etc."niri/config.kdl".source = ./config.kdl;
    };

    systemd.packages = [ pkgs.niri ];

    services = {
      desktopManager.cosmic.enable = true;
      displayManager.sessionPackages = [ pkgs.niri ];
      gnome.gnome-keyring.enable = true;
    };
  };
}
