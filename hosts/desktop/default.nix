{ lib, pkgs, ... }:
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
  #systemd.network.wait-online.anyInterface = true;
  #systemd.network.wait-online.timeout = 5;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
  ];
}
