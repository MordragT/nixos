{ pkgs, ... }:
{
    virtualisation.oci-containers.containers."minecraft" = {
        image = "minecraftservers/minecraft-server";
        ports = [
            "25565:25565/tcp"
            "25565:25565/udp"
        ];
        environment = {
            EULA = "TRUE";
        };
        autoStart = false;
    };
}