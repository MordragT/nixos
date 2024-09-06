{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.services.llama;
in {
  options.mordrag.services.llama = {
    enable = lib.mkEnableOption "Llama";
    settings = lib.mkOption {
      description = "Generates command-line arguments";
      default = {};
      type = lib.types.submodule {
        freeformType = with lib.types; let
          atom = nullOr (oneOf [
            bool
            str
            int
            float
          ]);
        in
          attrsOf (either atom (listOf atom));
        options = {
          host = lib.mkOption {
            description = "Which IP address to listen on.";
            default = "127.0.0.1";
            type = lib.types.str;
          };

          port = lib.mkOption {
            description = "Which port to listen on.";
            default = 8030;
            type = lib.types.port;
          };

          model = lib.mkOption {
            description = "Which model to serve";
            type = lib.types.str;
          };

          gpu-layers = lib.mkOption {
            description = "Number of layers to store in VRAM";
            default = 0;
            type = lib.types.int;
          };

          split-mode = lib.mkOption {
            description = "How to split the model across multiple GPUs";
            default = "none";
            type = lib.types.enum ["none" "layer" "row"];
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.llama-cpp = {
      description = "LLaMA C++ server";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      environment = {
        ZES_ENABLE_SYSMAN = "1";
      };
      serviceConfig = {
        Type = "idle";
        KillSignal = "SIGINT";
        Restart = "on-failure";
        RestartSec = 300;
        WorkingDirectory = "%S/llama-cpp";
        StateDirectory = ["llama-cpp"];
        DynamicUser = true;
        User = "llama-cpp";
        Group = "llama-cpp";
        ExecStart = "${pkgs.llama-cpp-sycl}/bin/llama-server ${toString (lib.cli.toGNUCommandLine {} cfg.settings)}";
      };
    };
  };
}
