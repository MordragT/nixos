{pkgs, ...}: {
  imports = [
    #./gitea.nix
    #./maddy.nix
    #./nextcloud.nix
    #./vaultwarden.nix
    #./sunshine.nix
    ./openssh.nix
    ./tailscale.nix
    # ./pia-wg.nix
  ];

  services.flatpak.enable = true;
  services.printing.enable = true;
  services.tor.enable = true;

  services.udev.packages = with pkgs; [
    platformio-core
    # openocd # plugdev errors are polluting the logs
  ];

  services.xserver.wacom.enable = true;
}
