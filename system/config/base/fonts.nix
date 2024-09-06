{pkgs, ...}: {
  # TODO
  # remove when https://github.com/NixOS/nixpkgs/issues/338933 is fixed
  # environment.sessionVariables = {
  #   FONTCONFIG_FILE = "${pkgs.fontconfig.out}/etc/fonts/fonts.conf";
  #   FONTCONFIG_PATH = "${pkgs.fontconfig.out}/etc/fonts";
  # };

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
