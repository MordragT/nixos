{ pkgs, ... }:
{
  programs.captive-browser = {
    enable = true;
    interface = "wlo1";
  };
  
  programs.wireshark.enable = true;
  programs.steam.enable = true;
  
  environment.systemPackages = with pkgs; [
    helix
    agenix
  ];
}