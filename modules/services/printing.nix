{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.services.printing;
in {
  options.mordrag.services.printing = {
    enable = lib.mkEnableOption "Printing";
  };

  config = lib.mkIf cfg.enable {
    hardware.sane = {
      enable = true;
      # extraBackends = [pkgs.hplipWithPlugin];
      extraBackends = [pkgs.hplip];
    };

    services.printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };

    services.system-config-printer.enable = true;
  };
}
