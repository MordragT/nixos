{pkgs, ...}: {
  home.packages = with pkgs; [
    blender
    # insecure electron16 blockbench-electron
    krita
    inkscape
    # glaxnimate
    # broken drawio
  ];
}
