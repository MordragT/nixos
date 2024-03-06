{pkgs, ...}: {
  services.xserver.displayManager.cosmic-greeter.enable = true;
  services.xserver.desktopManager.cosmic.enable = true;

  environment.systemPackages = with pkgs.gnome; [
    nautilus
    gnome-system-monitor
  ];

  programs.evince.enable = true;
  programs.file-roller.enable = true;
  programs.geary.enable = true;
  programs.gnome-disks.enable = true;

  services.gnome.gnome-keyring.enable = true;
  # quick previewer for nautilus
  services.gnome.sushi.enable = true;
}
