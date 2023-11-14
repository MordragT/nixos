{pkgs, ...}: {
  home.packages = with pkgs; [
    anytype # notion.so alternative
    miniserve # serve some files via http
    ffsend # securely share files
    appimage-run # run appimages
    scrcpy # control android from pc
    qbittorrent # download torrents
    popsicle # flash usb with iso
    rpi-imager # raspberry pi image flasher
    cachix # nix binary hosting
    silicon # rust tool to create beautiful code images
    nix-tree # browse nix store path dependencies
  ];
}
