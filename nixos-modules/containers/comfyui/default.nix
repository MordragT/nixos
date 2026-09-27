{ config, lib, ... }:
let
  cfg = config.mordrag.containers.comfyui;
in
{
  options.mordrag.containers.comfyui = {
    enable = lib.mkEnableOption "ComfyUI container (Intel XPU)";

    port = lib.mkOption {
      description = "Port to listen on";
      type = lib.types.port;
      example = 8188;
    };

    stateDir = lib.mkOption {
      description = "Base directory; models, nodes, workflows, user and output live underneath";
      type = lib.types.path;
      default = "/var/lib/comfyui";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = map (d: "d ${cfg.stateDir}/${d} 0755 1000 1000 -") [
      "models"
      "custom_nodes"
      "user"
    ];

    virtualisation.oci-containers.containers.comfyui = {
      image = "docker.io/reliqcontainers/comfyui:xpu-master";
      autoStart = true;

      ports = [ "127.0.0.1:${toString cfg.port}:8188" ];

      devices = [
        "/dev/dri/renderD128:/dev/dri/renderD128"
        "/dev/dri/card0:/dev/dri/card0"
      ];

      volumes = [
        "${cfg.stateDir}/models:/app/models"
        "${cfg.stateDir}/custom_nodes:/app/custom_nodes"
        "${cfg.stateDir}/user:/app/user"
      ];

      extraOptions = [
        "--ipc=host"
        "--group-add=keep-groups"
      ];

      environment.CUDA_VISIBLE_DEVICES = "";
    };
  };
}
