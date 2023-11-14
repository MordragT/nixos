{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira
      fira-code
      fira-mono
      jetbrains-mono
      roboto
      noto-fonts
      noto-fonts-emoji
      caladea # similar to microsoft cambria
      # needed for steam adwaita theme
      cantarell-fonts
      times-newer-roman
    ];
    fontconfig.defaultFonts = {
      monospace = ["Fira Mono"];
      serif = ["Noto Serif"];
      sansSerif = ["Fira Sans"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
