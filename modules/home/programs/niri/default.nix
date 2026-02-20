{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.programs.niri;
in {
  options.mordrag.programs.niri = {
    enable = lib.mkEnableOption "Niri";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."niri/config.kdl".source = ./config.kdl;
  };
}
