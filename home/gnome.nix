{ pkgs }:
with pkgs; [
  # Rust GTK
  rnote # draw notes
  contrast # gtk check contrast
  markets # gtk crypto market prices
  gnome-obfuscate # censor private information
  pika-backup # simple backups
  icon-library
  gnome-solanum # pomodoro timer

  # GTK Apps
  warp # send and recieve files
  khronos # track task time
  gnome.gnome-color-manager
  gnome.gnome-boxes
  gnome.gnome-todo
  gnome.gnome-sound-recorder
  gnome.ghex # hex editor
  pdfarranger
  junction # open with preview
  fragments # torrent downloader
]
