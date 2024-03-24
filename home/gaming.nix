{pkgs, ...}: {
  home.packages = with pkgs; [
    minecraft
    moonlight-qt # game stream client ala steam link
    optifine

    winPackages.battle-net

    # Emulation
    (retroarch.override {
      cores = with pkgs.libretro; [
        dolphin
      ];
    })
    # yuzu # switch emulation
  ];
}
