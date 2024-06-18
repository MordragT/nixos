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

    package = mkOption {
      description = "Which InvokeAI package to use.";
      type = types.package;
      default = pkgs.invokeai;
    };

    user = mkOption {
      description = "Which user to run InvokeAI as.";
      default = "invokeai";
      type = types.str;
    };

    group = mkOption {
      description = "Which group to run InvokeAI as.";
      default = "invokeai";
      type = types.str;
    };

    root = mkOption {
      description = "Where to store InvokeAI's state.";
      default = "/var/lib/invokeai";
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
            type = types.enum ["auto" "float32" "autocast" "float16"];
          };
        };
      };
    };
  };

  config = let
    config-file = builtins.toFile "invokeai.yaml" (lib.generators.toYAML {} cfg.settings);
  in
    lib.mkIf cfg.enable {
      users.users = lib.mkIf (cfg.user == "invokeai") {
        invokeai = {
          isSystemUser = true;
          inherit (cfg) group;
        };
      };
      users.groups = lib.mkIf (cfg.group == "invokeai") {
        invokeai = {};
      };

      # environment.etc."invokeai/invokeai.yaml" = {
      #   inherit (cfg) user group;
      #   text = lib.generators.toYAML {} cfg.settings;
      # };

      systemd.services.invokeai = {
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        environment = {
          HOME = "${cfg.root}";
          INVOKEAI_ROOT = "${cfg.root}";
          NIXIFIED_AI_NONINTERACTIVE = "1";
          # HUGGING_FACE_HUB_TOKEN = "";
          # SYCL_PI_TRACE = "-1";
          # ZE_DEBUG = "-1";

          # Enable Level Zero system management
          # See https://spec.oneapi.io/level-zero/latest/sysman/PROG.html
          ZES_ENABLE_SYSMAN = "1";

          # Force 100% available VRAM size for compute-runtime.
          # See https://github.com/intel/compute-runtime/issues/586
          NEOReadDebugKeys = "1";
          ClDeviceGlobalMemSizeAvailablePercent = "100";

          # ZE_RELAXED_ALLOCATION_LIMITS_EXP_FLAG_MAX_SIZE

          # Enable SYCL variables for cache reuse and single threaded mode.
          # See https://github.com/intel/llvm/blob/sycl/sycl/doc/EnvironmentVariables.md
          SYCL_CACHE_PERSISTENT = "1";
          SYCL_PI_LEVEL_ZERO_SINGLE_THREAD_MODE = "1";

          OCL_ICD_FILENAMES = "${pkgs.intel-dpcpp.runtime}/lib/libintelocl.so:/run/opengl-driver/lib/intel-opencl/libigdrcl.so";
        };
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = let
            args = lib.cli.toGNUCommandLine {} {
              inherit (cfg) root;
              # config = "${config-file}";
            };
          in "${lib.getExe cfg.package} ${toString args}";
          PrivateTmp = true;
        };
      };
      systemd.tmpfiles.rules = [
        "d '${cfg.root}' 0755 ${cfg.user} ${cfg.group} - -"
        "r '${cfg.root}/invokeai.yaml' - - - - -"
        "C '${cfg.root}/invokeai.yaml' 0755 ${cfg.user} ${cfg.group} - ${config-file}"
        # "L+ '${cfg.root}/invokeai.yaml' - - - - /etc/invokeai/invokeai.yaml"
      ];
    };
}
