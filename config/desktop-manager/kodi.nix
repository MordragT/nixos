{pkgs, ...}: {
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
}
