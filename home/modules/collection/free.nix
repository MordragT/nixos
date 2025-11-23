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
      # android-translation-layer # translation layer similar to wine, very wip
      brave

      # Editors
      # jetbrains.idea-community
      # lapce # code editor
      # octaveFull # aims to be compatible with matlab

      # Documents
      kdePackages.okular
      # onlyoffice-desktopeditors
      # libreoffice-qt6-fresh
      # xournalpp

      # Graphics
      blender
      blockbench
      drawio
      # glaxnimate
      inkscape
      krita
      gimp3

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
      dorion # rust written discord alternative
      # insomnia # make http requests against rest apis
      mattermost-desktop
      # broken protonvpn-gui
      qbittorrent # download torrents
      # rpi-imager # raspberry pi image flasher
    ];
  };
}
