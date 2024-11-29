{
  config,
  lib,
  ...
}: {
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "tom-laptop";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Desktop and Display Manager
  services.xserver.displayManager.gdm.enable = true;
  mordrag.desktop.gnome.enable = true;

  # Programs
  mordrag.programs.gnome-disks.enable = true;
  mordrag.programs.nautilus.enable = true;
  programs.captive-browser = {
    enable = true;
    interface = "wlp2s0";
  };
  programs.file-roller.enable = true;
  programs.geary.enable = true;
}
