{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.mordrag.hardware.intel-arc-a750 = lib.mkEnableOption "Intel ARC A750";

  config = lib.mkIf config.mordrag.hardware.intel-arc-a750 {
    # Force probe the i915 and xe drivers for the Intel Arc A750 GPU,
    # to enable experimental xe driver support.
    boot.kernelParams = [
      "i915.force_probe=!56a1"
      "xe.force_probe=56a1"
    ];

    security.wrappers.intel_gpu_top = {
      source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
      owner = "root";
      group = "wheel";
      permissions = "0750";
      capabilities = "cap_perfmon=ep";
    };

    # Hardware Acceleration
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-compute-runtime
        intel-compute-runtime.drivers
        intel-media-driver
        intel-vaapi-driver
        vpl-gpu-rt
      ];
    };
  };
}
