{pkgs, ...}: {
  home.pointerCursor = {
    enable = true;
    x11.enable = true;
    # gtk.enable = true;

    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 24;
  };

  imports = [
    ./nix.nix
    ./xdg.nix
  ];
}
