{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.collection.free;
in {
  options.mordrag.collection.free = {
    enable = lib.mkEnableOption "Free Software";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Must haves
      anarchism

      # Editors
      # jetbrains.idea-community
      # lapce # code editor
      # octaveFull # aims to be compatible with matlab

      # Documents
      # libreoffice-fresh
      kdePackages.okular
      # onlyoffice-bin_latest
      # xournalpp

      # Graphics
      blender
      # electron16 blockbench-electron
      # drawio
      # glaxnimate
      inkscape
      krita

      # Game Development
      # epic-asset-manager # manager for unreal engine and its assets
      # godot_4 # game engine

      # Media
      # olive-editor # video editor
      # spotube # use spotify to find music on youtube

      # Security
      # (cutter.withPlugins (plugins: with plugins; [jsdec rz-ghidra]))
      # tor-browser-bundle-bin

      # Other
      # dbeaver-bin # sql client
      # insomnia # make http requests against rest apis
      protonvpn-cli
      qbittorrent # download torrents
      # rpi-imager # raspberry pi image flasher
    ];
  };
}
