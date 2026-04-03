{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.core;
in
{
  options.mordrag.core = {
    enable = lib.mkEnableOption "Enable core settings";
  };

  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      enable = true;
      x11.enable = true;

      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 24;
    };

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        setSessionVariables = true;
      };
    };
  };
}
