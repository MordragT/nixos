{pkgs, ...}: {
  home.packages = with pkgs; [
    # Editors
    # jetbrains.idea-community
    # lapce # code editor
    # octaveFull # aims to be compatible with matlab

    # Documents
    # libreoffice-fresh
    # okular
    onlyoffice-bin_7_5
    xournalpp

    # Graphics
    blender
    # broken electron16 blockbench-electron
    # broken drawio
    # glaxnimate
    inkscape
    krita

    # Game Development
    # epic-asset-manager # manager for unreal engine and its assets
    godot_4 # game engine

    # Media
    # olive-editor # video editor
    # upscayl
    spotube # use spotify to find music on youtube

    # Security
    (cutter.withPlugins (cpkgs: with cpkgs; [jsdec rz-ghidra]))
    # tor-browser-bundle-bin

    # Other
    dbeaver # sql client
    # insomnia # make http requests against rest apis
    qbittorrent # download torrents
    # rpi-imager # raspberry pi image flasher
  ];
}
