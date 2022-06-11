{ pkgs, ... }:
{
    imports = [
        # ./vaultwarden.nix
        # ./gitea.nix
        ./caddy.nix
        # ./nextcloud.nix
        ./step-ca.nix
        # ./mailserver.nix
        # ./pia.nix
        # ./roundcube.nix
    ];

    services.sshd.enable = true;
    services.xserver.wacom.enable = true;
    services.printing.enable = true;
    services.flatpak.enable = true;
    services.tor.enable = true;
    services.logmein-hamachi.enable = false;
    # Keep this to not override caddy
    services.nginx.enable = false;

    services.mysql = {
        enable = false;
        package = pkgs.mariadb;
    };

    services.duplicati = {
        enable = false;
        user = "tom";
    };

    services.minecraft-server = {
        serverProperties = {
            difficulty = 3;
        };
        eula = true;
        openFirewall = true;
        enable = false;
    };

    services.xserver = {
        enable = true;
        layout = "de";
        displayManager.gdm = {
            enable = true;
            autoSuspend = false;
        };
        desktopManager.gnome.enable = true;
        # desktopManager.pantheon.enable = true;
        # videoDrivers = [ "amdgpu-pro" ];
    };
}
