{pkgs, ...}: {
  home.packages = with pkgs; [
    # Must haves
    anarchism

    # Editors
    # jetbrains.idea-community
    # lapce # code editor
    # octaveFull # aims to be compatible with matlab

    # Documents
    # libreoffice-fresh
    # okular
    onlyoffice-bin_latest
    xournalpp

    # Graphics
    blender
    # electron16 blockbench-electron
    # drawio
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
    # (cutter.withPlugins (plugins: with plugins; [jsdec rz-ghidra]))
    # tor-browser-bundle-bin

    # Other
    dbeaver # sql client
    # insomnia # make http requests against rest apis
    qbittorrent # download torrents
    # rpi-imager # raspberry pi image flasher
  ];
}
