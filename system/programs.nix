{ pkgs, ... }:
{
  programs.wireshark.enable = true;
  programs.steam.enable = true;
  programs.droidcam.enable = true;
  
  environment.systemPackages = with pkgs; [
    helix
    agenix
    findex
    gnome.gnome-tweaks
    gparted
    protontricks
  ];
}