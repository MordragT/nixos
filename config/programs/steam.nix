{pkgs, ...}: {
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # extest.enable = true;
    package = pkgs.steam.override {
      extraLibraries = pkgs:
        with pkgs; [
          # Crusader Kings 3
          ncurses
          libkrb5
          keyutils
          #gnome.zenity
          mangohud
        ];
    };
  };

  chaotic.steam.extraCompatPackages = with pkgs; [luxtorpeda proton-ge-custom steamtinkerlaunch];

  environment.systemPackages = with pkgs; [
    # steam-tui
    steamcmd
    steam-run
    sc-controller
    steamtinkerlaunch
    # steamcontroller
    # protonup-qt # replaced by chaotic luxtorpeda/proton-ge
    protontricks
  ];
}
