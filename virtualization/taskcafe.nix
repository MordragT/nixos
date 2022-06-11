{ pkgs, config, ... }:
{
    systemd.services.init-taskcafe-network = {
        description = "Create network bridge for taskcafe and its postgres db";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig.Type = "oneshot";
        script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
            in ''
            # Put a true at the end to prevent getting non-zero return code, which will
            # crash the whole service
            check=$(${dockercli} network ls | grep "taskcafe" || true)
            if [ -z "$check" ]; then
                ${dockercli} network create taskcafe
            else
                echo "taskcafe already exists in docker"
            fi
        '';
    };

    virtualisation.oci-containers.containers."taskcafe" = {
        image = "taskcafe/taskcafe";
        ports = [
            "3333:3333/tcp"
            "3333:3333/udp"
        ];
        environment = {
            TASKCAFE_DATABASE_HOST = "postgres";
            TASKCAFE_MIGRATE = "true";
        };
        dependsOn = [ "postgres" ];
        volumes = [
            "/home/tom/.local/share/taskcafe:/root/uploads"
        ];
        extraOptions = [
            "--network=taskcafe"
            # "--net=host"
        ];
    };

    virtualisation.oci-containers.containers."postgres" = {
        image = "postgres";
        environment = {
            POSTGRES_USER = "taskcafe";
            POSTGRES_PASSWORD = "taskcafe_test";
            POSTGRES_DB = "taskcafe";    
        };
        volumes = [
            "/home/tom/.local/share/postgres:/var/lib/postgresql/data"
        ];
        extraOptions = [
            "--network=taskcafe"
            # "--net=host"
        ];
    };
}