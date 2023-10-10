{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp2s0";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "tom-lenovo";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
