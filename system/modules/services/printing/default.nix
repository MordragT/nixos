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
      brscan4.enable = true;

      # extraBackends = [pkgs.hplipWithPlugin];
      extraBackends = [pkgs.hplip];

      brscan4.netDevices.brother = {
        model = "DCP-1610W";
        # nodename = "BRWA86BAD4E4C62";
        ip = "192.168.0.13";
      };
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
        brlaser
      ];
    };

    services.system-config-printer.enable = true;
  };
}
