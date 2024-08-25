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
  # broken programs.bandwhich.enable = true; # view network utilization
  programs.captive-browser = {
    enable = true;
    interface = "wlp39s0";
  };
  programs.corectrl.enable = true;
  programs.corectrl.gpuOverclock.enable = true;
  programs.file-roller.enable = true;
  programs.geary.enable = true;
  programs.seahorse.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
