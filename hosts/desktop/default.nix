{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp2s0";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  networking = {
    hostName = "tom-pc";
    useDHCP = false;
    useNetworkd = true;

    extraHosts = ''
      127.0.0.1 mordrag.io
    '';
  };
  systemd.services."systemd-networkd-wait-online".enable = false;
}