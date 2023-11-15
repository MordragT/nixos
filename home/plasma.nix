{pkgs, ...}: {
  home.packages = with pkgs.libsForQt5; [
    pkgs.stremio
    pkgs.partition-manager
    kdenetwork-filesharing
    dolphin
    kalk
    koko
    kweather
    kscreen
  ];
}
