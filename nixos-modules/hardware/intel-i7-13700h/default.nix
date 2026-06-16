{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.mordrag.hardware.intel-i7-13700h = lib.mkEnableOption "Intel I7 13700H";

  config = lib.mkIf config.mordrag.hardware.intel-i7-13700h {
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
