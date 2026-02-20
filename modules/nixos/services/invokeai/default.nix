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
    args = lib.cli.toCommandLineGNU {} {
      inherit root;
      # config = "${config-file}";
    };
    app = pkgs.makeChromiumApp {
      name = "invokeai";
      desktopName = "Invoke AI";
      app = "http://${cfg.settings.host}:${toString cfg.settings.port}";
      icon = "${cfg.package}/share/icons/invokeai/scalable/favicon.svg";
    };
  in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        app
      ];

      systemd.services.invokeai = {
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        environment = {
          HOME = "%C/invokeai";
          ZES_ENABLE_SYSMAN = "1";
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
