{pkgs, ...}: {
  home.packages = with pkgs; [
    # steam-tui
    steamcmd
    steam-run
    sc-controller
    # steamcontroller
    # lutris
    (retroarch.override {
      cores = with pkgs.libretro; [
        dolphin
      ];
    })
    bottles
    # protonup-qt # replaced by chaotic luxtorpeda/proton-ge
    protontricks
    # minecraft
    optifine
    gamescope
    mangohud
    # unigine-superposition # benchmark
    # geekbench # benchmark
    moonlight-qt # game stream client ala steam link
    yuzu # switch emulation
  ];
}
