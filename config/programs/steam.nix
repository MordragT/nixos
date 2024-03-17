{pkgs, ...}: {
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # extest.enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
      };
      extraLibraries = pkgs:
        with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils

          gamemode
        ];
    };
    extraCompatPackages = with pkgs; [
      luxtorpeda
      proton-ge-custom
      steamtinkerlaunch
      # compatPackages.wine-unstable
    ];
  };

  environment.systemPackages = with pkgs; [
    steamcmd
    steam-run
    sc-controller
    protontricks
  ];
}
