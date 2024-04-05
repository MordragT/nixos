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
    loupe # image viewer
    markets # gtk crypto market prices
    overskride # bluetooth client

    # GTK Apps
    bottles
    fractal-next # gtk matrix messaging
    gnome.gnome-boxes
    gnome.gnome-sound-recorder
    gnome.ghex # hex editor
    gnome.gnome-tweaks
    # lutris
    # broken popsicle # flash usb with iso
  ];
}
