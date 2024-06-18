{
  config,
  lib,
  ...
}: {
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "tom-laptop";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  mordrag.desktop.gnome.enable = true;
  mordrag.programs.gnome-disks.enable = true;
  mordrag.programs.nautilus.enable = true;
  programs.captive-browser = {
    enable = true;
    interface = "wlp2s0";
  };
  programs.file-roller.enable = true;
  programs.geary.enable = true;
}
