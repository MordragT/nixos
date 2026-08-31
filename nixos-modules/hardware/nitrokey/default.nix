{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.mordrag.hardware.nitrokey = lib.mkEnableOption "NitroKey";

  config = lib.mkIf config.mordrag.hardware.nitrokey {
    environment.systemPackages = [
      pkgs.nitrokey-app2
    ];

    hardware = {
      gpgSmartcards.enable = true;
      nitrokey.enable = true;
    };
  };
}
