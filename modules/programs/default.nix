{...}: {
  imports = [
    ./steam.nix
    ./comma.nix
  ];

  programs.adb.enable = true;
  programs.bandwhich.enable = true; # view network utilization
  programs.droidcam.enable = true;
  programs.gamemode.enable = true;
  programs.wireshark.enable = true;
}
