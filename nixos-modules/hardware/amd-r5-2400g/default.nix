{
  config,
  lib,
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

    boot.kernelModules = [ "kvm-amd" ];
  };
}
