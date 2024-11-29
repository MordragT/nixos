{pkgs, ...}: let
  kodi = pkgs.private.kodi.withPackages (p:
    with p; [
      # youtube # invidious
      sponsorblock
      netflix
      steam-launcher
      steam-controller
      # broken osmc-skin
      mediathekview
    ]);
in {
  specialisation.kodi.configuration = {
    system.nixos.tags = ["kodi"];

    # Define a user account
    users.extraUsers.kodi.isNormalUser = true;

    # Kodi Kiosk Mode
    services.cage = {
      enable = true;
      user = "kodi";
      program = "${kodi}/bin/kodi-standalone";
    };

    # Kodi Remote
    networking.firewall.allowedTCPPorts = [8080];
    networking.firewall.allowedUDPPorts = [8080];
  };
}
