{pkgs, ...}: {
  home.packages = with pkgs; [
    # byfl # compiler based application analysis
    # likwid # performance monitoring
    # renderdoc # debug graphics
    vkmark
    # vulkan-raytracing
  ];
}
