{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.collection.plasma;
in {
  options.mordrag.collection.plasma = {
    enable = lib.mkEnableOption "Plasma";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.libsForQt5; [
      pkgs.stremio
      pkgs.partition-manager
      kdenetwork-filesharing
      dolphin
      kalk
      koko
      kweather
      kscreen
    ];
  };
}
