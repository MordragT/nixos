{
  config,
  lib,
  ...
}:
{
  mordrag = {
    bluetooth.enable = true;
    boot.enable = true;
    core.enable = true;
    desktop = {
      gnome.enable = true;
    };
    fonts.enable = true;
    locale.enable = true;
    networking.enable = true;
    nix.enable = true;
    pipewire.enable = true;
    programs = {
      gnome-disks.enable = true;
      nautilus.enable = true;
    };
    secrets.enable = true;
    security.enable = true;
    users.enable = true;
    virtualisation.enable = true;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    cpu = {
      intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };

  services = {
    displayManager = {
      gdm.enable = true;
    };
  };

  programs = {
    captive-browser = {
      enable = true;
      interface = "wlp2s0";
    };
    geary.enable = true;
  };

}
