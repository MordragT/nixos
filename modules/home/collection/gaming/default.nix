{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.collection.gaming;
in
{
  options.mordrag.collection.gaming = {
    enable = lib.mkEnableOption "Gaming";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # heroic # game launcher works pretty bad on nixos
      prismlauncher
      # ferium # minecraft cli
      # optifine
      # moonlight-qt # game stream client ala steam link
      # nexusmods-app-unfree
      steam-rom-manager
      teamfight-tactics
    ];
  };
}
