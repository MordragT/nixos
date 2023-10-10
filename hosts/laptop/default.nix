{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlo1";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "tom-laptop";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
