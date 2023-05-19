{ pkgs, ... }:
{

  imports = [
    #./gitea.nix
    #./maddy.nix
    #./nextcloud.nix
    #./vaultwarden.nix
  ];

  services.flatpak.enable = true;

  services.mysql = {
    enable = false;
    package = pkgs.mariadb;
  };

  services.printing.enable = true;
  services.ratbagd.enable = true; # gaming mice daemon
  services.sshd.enable = true;
  services.tor.enable = true;

  services.udev.packages = with pkgs; [
    platformio-core
    openocd
  ];

  services.xserver.wacom.enable = true;
}
