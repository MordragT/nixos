{pkgs, ...}: {
  home.packages = with pkgs; [
    # byfl # compiler based application analysis
    # likwid # performance monitoring
    phoronix-test-suite
    # renderdoc # debug graphics
    vkmark
  ];
}
