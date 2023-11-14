{pkgs, ...}: {
  home.packages = with pkgs.libsForQt5; [
    kalk
    koko
    kweather
    kscreen
  ];
}
