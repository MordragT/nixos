{pkgs, ...}: {
  mordrag.programs.gnome-disks.enable = true;
  # mordrag.programs.gnome-network-displays.enable = true;
  mordrag.programs.mediatek-utils.enable = true;
  mordrag.programs.nautilus.enable = true;
  mordrag.programs.steam = {
    enable = true;
    compatPackages = with pkgs; [
      # proton-ge-bin
      proton-ge-custom
      luxtorpeda
      proton-cachyos-bin
      opengothic
      # steamtinkerlaunch
    ];
  };
  # broken mordrag.programs.valent.enable = true;

  programs.adb.enable = true;
  programs.ausweisapp.enable = true;
  # programs.bandwhich.enable = true; # view network utilization
  # programs.captive-browser = {
  #   enable = true;
  #   interface = "wlp39s0";
  # };
  # programs.corectrl.enable = true;
  # programs.corectrl.gpuOverclock.enable = true;
  programs.droidcam.enable = true;
  programs.file-roller.enable = true;
  # programs.geary.enable = true;
  # programs.seahorse.enable = true;
  # programs.wireshark = {
  #   enable = true;
  #   package = pkgs.wireshark;
  # };
}
