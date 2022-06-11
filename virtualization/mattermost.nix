{ pkgs, ... }:
{
    virtualisation.oci-containers.containers."mattermost" = {
        image = "mattermost/mattermost-preview";
        ports = [
            "8065:8065/tcp"
            "8065:8065/udp"
        ];
        autoStart = false;
    };
}