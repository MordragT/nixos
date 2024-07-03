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
    root = "/var/lib/invokeai";
    config-file = builtins.toFile "invokeai.yaml" (lib.generators.toYAML {} cfg.settings);
    args = lib.cli.toGNUCommandLine {} {
      inherit root;
      # config = "${config-file}";
    };
  in
    lib.mkIf cfg.enable {
      systemd.services.invokeai = {
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        environment = {
          HOME = "%C/invokeai";
          ZES_ENABLE_SYSMAN = "1";
          OCL_ICD_FILENAMES = "${pkgs.intel-dpcpp.runtime}/lib/libintelocl.so:/run/opengl-driver/lib/intel-opencl/libigdrcl.so";
        };
        serviceConfig = {
          WorkingDirectory = root;
          StateDirectory = ["invokeai"];
          CacheDirectory = ["invokeai"];
          DynamicUser = true;
          User = "invokeai";
          Group = "invokeai";
          ExecStart = "${lib.getExe cfg.package} ${toString args}";
        };
      };
      systemd.tmpfiles.rules = [
        "d '${root}' 0755 invokeai invokeai - -"
        "r '${root}/invokeai.yaml' - - - - -"
        "C '${root}/invokeai.yaml' 0755 invokeai invokeai - ${config-file}"
      ];
    };
}
