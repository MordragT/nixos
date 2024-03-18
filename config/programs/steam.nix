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
    extraCompatPackages = with pkgs.compatPackages; [
      luxtorpeda
      proton
      steamtinkerlaunch
      wine-unstable
      opengothic
    ];
  };

  environment.systemPackages = with pkgs; [
    steamcmd
    steam-run
    sc-controller
    protontricks
  ];
}
