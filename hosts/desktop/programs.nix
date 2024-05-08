{...}: {
  programs.adb.enable = true;
  programs.bandwhich.enable = true; # view network utilization
  programs.captive-browser = {
    enable = true;
    interface = "wlp39s0";
  };
  programs.corectrl.enable = true;
  programs.corectrl.gpuOverclock.enable = true;
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
  programs.wireshark.enable = true;
  programs.valent.enable = true;
}
