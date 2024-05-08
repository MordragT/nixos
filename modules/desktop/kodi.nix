{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.kodi;
in {
  options = {
    desktop.kodi = {
      enable = lib.mkEnableOption "Kodi";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.displayManager.autoLogin = {
      enable = false;
      user = "tom";
    };

    services.xserver.desktopManager.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (pkgs:
        with pkgs; [
          steam-launcher
          steam-controller
          netflix
          youtube
          # nervt jellyfin
          # broken osmc-skin
          libretro
        ]);
    };
  };
}
