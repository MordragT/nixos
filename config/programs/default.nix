{...}: {
  imports = [
    ./steam.nix
    ./valent.nix
  ];

  programs.adb.enable = true;
  programs.bandwhich.enable = true; # view network utilization
  programs.corectrl.enable = true;
  programs.corectrl.gpuOverclock.enable = true;
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.wireshark.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;
}
