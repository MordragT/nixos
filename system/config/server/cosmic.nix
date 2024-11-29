{pkgs, ...}: {
  specialisation.cosmic.configuration = {
    system.nixos.tags = ["cosmic"];

    # Desktop & Display Manager
    services.displayManager.cosmic-greeter.enable = true;
    mordrag.desktop.cosmic.enable = true;

    # needed for protonvpn
    # https://github.com/NixOS/nixpkgs/issues/294750
    programs.nm-applet.enable = true;
    environment.systemPackages = with pkgs; [
      protonvpn-gui
    ];
    mordrag.programs.gnome-disks.enable = true;
    # mordrag.services.samba.enable = true;
  };
}
