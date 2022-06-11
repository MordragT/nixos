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
    
    # interfaces.enp5s0.useDHCP = true;
    # interfaces.wlp2s0.useDHCP = true;
    extraHosts = ''
      127.0.0.1 mordrag.io
    '';
  };
}
