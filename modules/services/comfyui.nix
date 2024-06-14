{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mordrag.services.comfyui;
in {
  options.mordrag.services.comfyui = {
    enable =
      mkEnableOption
      (mdDoc "The most powerful and modular stable diffusion GUI with a graph/nodes interface.");

    dataPath = mkOption {
      type = types.str;
      default = "/var/lib/comfyui";
      description = mdDoc "path to the folders which stores models, custom nodes, input and output files";
    };

    package = mkOption {
      type = types.package;
      default = (
        if config.cudaSupport
        then pkgs.comfyui-cuda
        else if config.rocmSupport
        then pkgs.comfyui-rocm
        else pkgs.comfyui
      );
      defaultText = literalExpression "pkgs.comfyui";
      example = literalExpression "pkgs.comfyui-rocm";
      description = mdDoc "ComfyUI base package to use";
    };

    user = mkOption {
      type = types.str;
      default = "comfyui";
      example = "yourUser";
      description = mdDoc ''
        The user to run ComfyUI as.
        By default, a user named `comfyui` will be created whose home
        directory will contain input, output, custom nodes and models.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "comfyui";
      example = "yourGroup";
      description = mdDoc ''
        The group to run ComfyUI as.
        By default, a group named `comfyui` will be created.
      '';
    };
    port = mkOption {
      type = types.int;
      default = 8000;
      description = mdDoc "Set the listen port for the Web UI and API.";
    };

    customNodes = mkOption {
      type = types.listOf types.package;
      default = [];
      description = mdDoc "custom nodes to add to the ComfyUI setup. Expects a list of packages from pkgs.comfyui-custom-nodes";
    };

    extraArgs = mkOption {
      type = types.str;
      default = "";
      example = "--preview-method auto";
      description = mdDoc ''
        Additional arguments to be passed to comfyui
      '';
    };
  };

  config = mkIf cfg.enable {
    # users.users = {
    #   ${cfg.user} = {
    #     group = cfg.group;
    #     home = cfg.dataPath;
    #     description = "ComfyUI daemon user";
    #     isSystemUser = true;
    #   };
    # };

    # users.groups = {
    #   ${cfg.group} = {};
    # };

    # systemd.tmpfiles.rules = [
    #   "d ${cfg.dataPath}/input - ${cfg.user} ${cfg.group}"
    #   "d ${cfg.dataPath}/output - ${cfg.user} ${cfg.group}"
    #   "d ${cfg.dataPath}/custom_nodes - ${cfg.user} ${cfg.group}"
    #   "d ${cfg.dataPath}/models - ${cfg.user} ${cfg.group}"
    #   "d ${cfg.dataPath}/temp - ${cfg.user} ${cfg.group}"
    #   "d ${cfg.dataPath}/user - ${cfg.user} ${cfg.group}"
    # ];

    systemd.services.comfyui = {
      description = "ComfyUI Service";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        # User = cfg.user;
        # Group = cfg.group;
        ExecStart = let
          args = cli.toGNUCommandLine {} {
            port = cfg.port;
          };
        in ''
          ${cfg.package}/bin/comfyui ${toString args} ${cfg.extraArgs}
        '';
        StateDirectory = ["comfyui"];
        RuntimeDirectory = ["comfyui"];
        WorkingDirectory = "/run/comfyui";
        Restart = "always"; # comfyui is prone to crashing on long slow workloads.
      };
    };
  };
}
