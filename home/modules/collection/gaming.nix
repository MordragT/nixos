{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.collection.gaming;
in {
  options.mordrag.collection.gaming = {
    enable = lib.mkEnableOption "Gaming";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
      # ferium
      # optifine
      # moonlight-qt # game stream client ala steam link
      # nexusmods-app-unfree
    ];
  };
}
