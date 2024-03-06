{pkgs, ...}: {
  programs.hyprland.enable = true;

  xdg.portal.configPackages = [
    (pkgs.writeTextDir "share/xdg-desktop-portal/hyprland-portals.conf" ''
      [preferred]
      default=gtk;hyprland
    '')
  ];
}
