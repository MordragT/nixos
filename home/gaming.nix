{pkgs, ...}: {
  home.packages = with pkgs; [
    # steam-tui
    steamcmd
    steam-run
    sc-controller
    # steamcontroller
    # lutris
    retroarchFull
    bottles
    protonup-qt
    protontricks
    vulkan-tools
    minecraft
    optifine
    gamescope
    mangohud
    # unigine-superposition # benchmark
    # geekbench # benchmark
    moonlight-qt # game stream client ala steam link
  ];
}
