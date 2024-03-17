{pkgs, ...}: {
  home.packages = with pkgs; [
    # gamescope
    minecraft
    moonlight-qt # game stream client ala steam link
    # opengothic
    optifine

    # Emulation
    (retroarch.override {
      cores = with pkgs.libretro; [
        dolphin
      ];
    })
    # yuzu # switch emulation
  ];
}
