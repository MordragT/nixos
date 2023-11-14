{pkgs, ...}: {
  home.packages = with pkgs.libsForQt5; [
    pkgs.partition-manager
    kalk
    koko
    kweather
    kscreen
  ];
}
