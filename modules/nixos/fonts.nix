{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mordrag.fonts;
in {
  options.mordrag.fonts = {
    enable = lib.mkEnableOption "Fonts";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.adwaita-icon-theme];
    xdg.icons.enable = true;
    xdg.icons.fallbackCursorThemes = ["Adwaita"];

    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages = with pkgs; [
        adwaita-fonts
        corefonts
        # caladea # similar to microsoft cambria
        # cantarell-fonts # needed for steam adwaita theme
        fira
        fira-code
        fira-mono
        geist-font
        # inter
        # iosevka
        # jetbrains-mono
        lucide
        noto-fonts
        noto-fonts-color-emoji
        # roboto
        # times-newer-roman
        # victor-mono
      ];
      fontconfig.defaultFonts = {
        monospace = ["Geist Mono"];
        serif = ["Geist"];
        sansSerif = ["Geist"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
