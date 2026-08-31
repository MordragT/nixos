{
  lib,
  config,
  ...
}:
{
  options.mordrag.hardware.tuxedo = lib.mkEnableOption "Tuxedo";

  config = lib.mkIf config.mordrag.hardware.tuxedo {
    hardware = {
      tuxedo-drivers.enable = true;
      tuxedo-rs = {
        enable = true;
        tailor-gui.enable = true;
      };
    };
  };
}
