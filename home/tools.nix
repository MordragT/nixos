{pkgs, ...}: {
  home.packages = with pkgs; [
    anytype # notion.so alternative
    miniserve # serve some files via http
    ffsend # securely share files
    appimage-run # run appimages
    scrcpy # control android from pc
    qbittorrent # download torrents
    popsicle # flash usb with iso
    cachix # nix binary hosting
    silicon # rust tool to create beautiful code images
    comma # run nix programs without installing
    nix-tree # browse nix store path dependencies
  ];
}
