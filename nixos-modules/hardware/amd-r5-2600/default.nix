{
  config,
  lib,
  ...
}:
{
  options.mordrag.hardware.amd-r5-2600 = lib.mkEnableOption "AMD R5 2600";

  config = lib.mkIf config.mordrag.hardware.amd-r5-2600 {
    powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

    hardware = {
      enableRedistributableFirmware = true;
      cpu.amd.updateMicrocode = true;
    };

    boot.kernelModules = [ "kvm-amd" ];
  };
}
