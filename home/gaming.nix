{pkgs, ...}: {
  home.packages = with pkgs; [
    # steam-tui
    steamcmd
    steam-run
    sc-controller
    # steamcontroller
    # lutris
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
  ];
}
