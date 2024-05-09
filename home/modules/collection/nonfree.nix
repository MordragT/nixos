{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.collection.nonfree;
in {
  options.mordrag.collection.nonfree = {
    enable = lib.mkEnableOption "Non-Free Software";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
      # matlab
      # spotify # spotube is far better # listen to music
      teamspeak_client
      # broken teams-for-linux # microsoft teams
      # unigine-superposition
      # zoom-us
      webex
      # whatsapp-for-linux
    ];
  };
}
