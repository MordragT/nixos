{ pkgs }:
with pkgs; [
  miniserve # serve some files via http
  ffsend # securely share files
  appimage-run # run appimages
  scrcpy # control android from pc
  qbittorrent # download torrents
]
