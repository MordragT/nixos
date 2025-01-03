{pkgs, ...}: {
  environment.systemPackages = [pkgs.adwaita-icon-theme];
  xdg.icons.enable = true;
  xdg.icons.fallbackCursorThemes = ["Adwaita"];

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      # caladea # similar to microsoft cambria
      # cantarell-fonts # needed for steam adwaita theme
      fira
      fira-code
      fira-mono
      geist-font
      # inter
      # iosevka
      # jetbrains-mono
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
}
