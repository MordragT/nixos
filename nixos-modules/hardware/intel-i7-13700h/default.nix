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

    boot = {
      kernelModules = [ "kvm-intel" ];

      # Force xe driver for igpu
      kernelParams = [
        "i915.enable_guc=3"
        "i915.enable_psr=0"
        # "i915.force_probe=!a7a0"
        # "xe.force_probe=a7a0"
        # Disable PSR on xe driver (fixes HDMI + flickering)
        # "xe.enable_psr=0"
      ];
    };

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
          level-zero
        ];
      };
    };
  };
}
