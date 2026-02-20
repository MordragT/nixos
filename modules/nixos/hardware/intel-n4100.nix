{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.mordrag.hardware.intel-n4100 = lib.mkEnableOption "Intel N4100";

  config = lib.mkIf config.mordrag.hardware.intel-n4100 {
    powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-media-driver
        intel-vaapi-driver
      ];
    };
  };
}
