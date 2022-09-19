{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira
      fira-code
      jetbrains-mono
      roboto
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Fira Code" ];
      serif = [ "Noto Serif" ];
      sansSerif = [ "Fira Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
