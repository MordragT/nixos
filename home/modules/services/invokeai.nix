{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.mordrag.services.invokeai;
in {
  options.mordrag.services.invokeai = {
    enable = lib.mkEnableOption "InvokeAI Web UI for Stable Diffusion";
    package = lib.mkPackageOption pkgs "invokeai" {};

    root = mkOption {
      description = "Where to store InvokeAI's state.";
      default = "${config.xdg.dataHome}/invokeai";
      type = types.path;
    };

    settings = mkOption {
      description = "Generates `invokeai.yaml` configuration file";
      default = {};
      type = types.submodule {
        freeformType = with types; let
          atom = nullOr (oneOf [
            bool
            str
            int
            float
          ]);
        in
          attrsOf (either atom (listOf atom));
        options = {
          schema_version = mkOption {
            description = "Internal metadata - do not edit";
            default = "4.0.1";
            type = types.str;
          };

          host = mkOption {
            description = "Which IP address to listen on.";
            default = "127.0.0.1";
            type = types.str;
          };

          port = mkOption {
            description = "Which port to listen on.";
            default = 9090;
            type = types.port;
          };

          precision = mkOption {
            description = "Set model precision.";
            default = "auto";
            type = types.enum ["auto" "float32" "bfloat16" "float16"];
          };
        };
      };
    };
  };

  config = let
    config-file = builtins.toFile "invokeai.yaml" (lib.generators.toYAML {} cfg.settings);
  in
    lib.mkIf cfg.enable {
      systemd.user.services.invokeai = {
        Service = {
          Environment = [
            "INVOKEAI_ROOT=${cfg.root}"
            "ZES_ENABLE_SYSMAN=1"
          ];

          ExecStart = let
            args = lib.cli.toGNUCommandLine {} {
              inherit (cfg) root;
              config = "${config.xdg.configHome}/invokeai/invokeai.yaml";
            };
          in "${lib.getExe cfg.package} ${toString args}";
        };
      };

      systemd.user.tmpfiles.rules = [
        "d '${cfg.root}/configs' - - - - -"
        "r '${config.xdg.configHome}/invokeai/invokeai.yaml' - - - - -"
        "C '${config.xdg.configHome}/invokeai/invokeai.yaml' 0755 - - - ${config-file}"
      ];

      home.packages = [
        pkgs.python3Packages.huggingface-hub
      ];
    };
}
