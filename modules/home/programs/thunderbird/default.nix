{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.thunderbird;
in
{
  options.mordrag.programs.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird";
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird;
      profiles.options = {
        isDefault = true;
      };
    };
  };
}
