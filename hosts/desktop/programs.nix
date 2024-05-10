{pkgs, ...}: {
  mordrag.programs.gnome-disks.enable = true;
  mordrag.programs.nautilus.enable = true;
  mordrag.programs.steam = {
    enable = true;
    compatPackages = with pkgs.steamPackages; [
      proton-ge-bin
      proton-cachyos-bin
      luxtorpeda
      opengothic
      steamtinkerlaunch
    ];
  };
  mordrag.programs.valent.enable = true;

  programs.adb.enable = true;
  programs.bandwhich.enable = true; # view network utilization
  programs.captive-browser = {
    enable = true;
    interface = "wlp39s0";
  };
  programs.corectrl.enable = true;
  programs.corectrl.gpuOverclock.enable = true;
  programs.evince.enable = true;
  programs.file-roller.enable = true;
  # programs.gamescope.args = [
  #   "-W 2560"
  #   "-H 1440"
  #   "-w 1920"
  #   "-h 1080"
  #   "-r 120"
  #   "-f"
  #   "--rt"
  #   "--display-index 1"
  #   "--immediate-flips"
  # ];
  programs.geary.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
