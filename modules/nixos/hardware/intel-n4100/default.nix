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

    boot.kernelModules = [ "kvm-intel" ];

    hardware = {
      enableRedistributableFirmware = true;
      cpu.intel.updateMicrocode = true;

      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-compute-runtime
          intel-compute-runtime.drivers
          intel-media-driver
          vpl-gpu-rt
        ];
      };
    };
  };
}
