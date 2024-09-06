{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.livebook;
in {
  options.mordrag.services.livebook = {
    enable = lib.mkEnableOption "Livebook";
  };

  config = lib.mkIf cfg.enable {
    services.livebook = {
      enableUserService = true;
      environmentFile = null;
    };
  };
}
