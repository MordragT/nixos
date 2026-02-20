{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.programs.helix;
in
{
  options.mordrag.programs.helix = {
    enable = lib.mkEnableOption "Helix";
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      settings = {
        theme = "gruvbox";
      };
    };
  };
}
