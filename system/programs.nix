{ pkgs, ... }:
{
  
  programs.wireshark.enable = true;
  programs.steam.enable = true;
  
  environment.systemPackages = with pkgs; [
    helix
    agenix
    gnome.gnome-tweaks
    gparted
  ];
}