{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlo1";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking = {
    hostName = "tom-laptop";
    useDHCP = false;

    interfaces.enp2s0.useDHCP = true;
    interfaces.wlo1.useDHCP = true;
    extraHosts = ''
      127.0.0.1 mordrag.io
    '';
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
