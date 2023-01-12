{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    layout = "de";
    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.pop-shell
    gnomeExtensions.space-bar
    gnomeExtensions.rounded-window-corners
    gnome-shell-extension-fly-pie
    #adw-gtk3
  ];
}
