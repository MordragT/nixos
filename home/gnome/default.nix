{pkgs, ...}: {
  imports = [
    ./circle.nix
    ./graphics.nix
    ./media.nix
    ./office.nix
  ];

  home.packages = with pkgs; [
    # Rust GTK
    # czkawka # duplicate finder
    fclones-gui # find duplicate files
    markets # gtk crypto market prices

    # GTK Apps
    bottles
    fractal-next # gtk matrix messaging
    gnome.gnome-boxes
    gnome.gnome-sound-recorder
    gnome.ghex # hex editor
    # lutris
    # broken popsicle # flash usb with iso
  ];
}
