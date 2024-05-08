{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.livebook;
in {
  options = {
    mordrag.livebook = {
      enable = lib.mkEnableOption "Livebook";
    };
  };

  config = lib.mkIf cfg.enable {
    services.livebook = {
      enableUserService = true;
      environmentFile = null;
    };
  };
}
