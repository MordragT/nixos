{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.mordrag.hardware.amd-r5-2400g = lib.mkEnableOption "AMD R5 2400G";

  config = lib.mkIf config.mordrag.hardware.amd-r5-2400g {
    powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

    hardware = {
      enableRedistributableFirmware = true;
      cpu.amd.updateMicrocode = true;

      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    boot = {
      kernelModules = [ "kvm-amd" ];
      kernelParams = [
        # Disable Retbleed mitigations on Zen+ (Ryzen 5 2600) for 5-20% perf gain.
        # Low risk on single-user home setups (needs local code exec); safe for gaming.
        "retbleed=off"
      ];
    };
  };
}
