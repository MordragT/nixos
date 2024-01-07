{pkgs, ...}: {
  home.packages = with pkgs; [
    contrast # gtk check contrast
    gnome.gnome-color-manager
    icon-library
    paleta # extract dominant color from images
  ];
}
