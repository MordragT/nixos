{
  config,
  lib,
  ...
}:
{
  options.mordrag.hardware.amd-r5-2600 = lib.mkEnableOption "AMD R9 3900x";

  config = lib.mkIf config.mordrag.hardware.amd-r5-2600 {
    # Required by amd-pstate-epp
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

    hardware = {
      enableRedistributableFirmware = true;
      cpu.amd.updateMicrocode = true;
    };

    boot.kernelModules = [
      "kvm-amd"
      "amd-pstate"
    ];
  };
}
