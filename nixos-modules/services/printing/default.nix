{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.services.printing;
in
{
  options.mordrag.services.printing = {
    enable = lib.mkEnableOption "Printing";
  };

  config = lib.mkIf cfg.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.hplip ];
    };

    services = {
      printing = {
        enable = true;
        # deprecated drivers = [ pkgs.hplip ];
      };

      # This installs a web interface for cups
      # system-config-printer.enable = true;
    };
  };
}
