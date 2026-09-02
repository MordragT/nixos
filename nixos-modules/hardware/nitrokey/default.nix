{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.mordrag.hardware.nitrokey = lib.mkEnableOption "NitroKey";

  config = lib.mkIf config.mordrag.hardware.nitrokey {
    environment.systemPackages = with pkgs; [
      nitrokey-app2
      pynitrokey
      libfido2
    ];

    hardware = {
      gpgSmartcards.enable = true;
      nitrokey.enable = true;
    };
  };
}
