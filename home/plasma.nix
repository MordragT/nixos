{pkgs, ...}: {
  home.packages = with pkgs.libsForQt5; [
    plasmatube # youtube
    audiotube # youtube audio
    kalk
    koko
    kweather
  ];
}
