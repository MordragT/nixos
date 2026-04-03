{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mordrag.platform.fonts;
in
{
  options.mordrag.platform.fonts = {
    enable = lib.mkEnableOption "Fonts";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.adwaita-icon-theme ];

    xdg.icons = {
      enable = true;
      fallbackCursorThemes = [ "Adwaita" ];
    };

    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages = with pkgs; [
        adwaita-fonts
        corefonts
        fira
        fira-code
        fira-mono
        geist-font
        inter
        lucide
        noto-fonts
        noto-fonts-color-emoji
        roboto
      ];
      fontconfig.defaultFonts = {
        monospace = [ "Geist Mono" ];
        serif = [ "Geist" ];
        sansSerif = [ "Geist" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
