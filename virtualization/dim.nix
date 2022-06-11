{ pkgs, ... }:
{
    virtualisation.oci-containers.containers."dim" = {
        image = "ghcr.io/dusk-labs/dim:dev";
        ports = [
            "8000:8000/tcp"   
        ];
        volumes = [
            "/home/tom/.config/dim:/opt/dim/config"
            "/home/tom/Videos:/media"
        ];
        autoStart = false;
    };
}

