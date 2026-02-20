{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mordrag.bluetooth;
in
{
  options.mordrag.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez; # pkgs.bluez5-experimental;
      powerOnBoot = false;

      settings = {
        General = {
          # Name = "Hello";
          # ControllerMode = "dual";
          # FastConnectable = "true";
          Experimental = "true";
        };
        # Policy = {
        #   AutoEnable = "true";
        # };
      };
    };
  };
}
