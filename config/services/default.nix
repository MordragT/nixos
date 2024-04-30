{pkgs, ...}: {
  imports = [
    #./gitea.nix
    #./maddy.nix
    #./nextcloud.nix
    #./vaultwarden.nix
    #./sunshine.nix
    ./openssh.nix
    ./printing.nix
    ./tailscale.nix
  ];

  services.flatpak.enable = true;
  services.tor.enable = true;

  services.udev.packages = with pkgs; [
    platformio-core
    # openocd # plugdev errors are polluting the logs
  ];

  services.xserver.wacom.enable = true;
}
