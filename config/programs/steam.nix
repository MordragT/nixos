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
    extraCompatPackages = with pkgs.steamPackages; [
      proton-ge-bin
      proton-cachyos-bin
      luxtorpeda
      opengothic
      steamtinkerlaunch
    ];
  };

  environment.systemPackages = with pkgs; [
    steamPackages.steamcmd
    steam-run
    sc-controller
    protontricks
  ];
}
