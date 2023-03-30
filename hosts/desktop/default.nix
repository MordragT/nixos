{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp39s0";
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
  # https://github.com/NixOS/nixpkgs/issues/180175
  #systemd.services.NetworkManager-wait-online.enable = false;
  #systemd.services.systemd-networkd-wait-online.restartIfChanged = false;
  #systemd.services.systemd-udevd.restartIfChanged = false;
  systemd.network.wait-online.anyInterface = true;
  systemd.network.wait-online.timeout = 5;
}
