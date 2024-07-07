{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;

  cfg = config.mordrag.services.tabby;
  format = pkgs.formats.toml {};
  tabbyPackage = cfg.package.override {
    inherit (cfg) acceleration;
  };
in {
  options.mordrag.services.tabby = {
    enable = lib.mkEnableOption "Self-hosted AI coding assistant using large language models";
    package = lib.mkPackageOption pkgs "tabby" {};

    port = lib.mkOption {
      type = types.port;
      default = 11029;
    };

    chatModel = lib.mkOption {
      type = types.str;
      default = "TabbyML/Qwen2-1.5B-Instruct";
    };

    model = lib.mkOption {
      type = types.str;
      default = "TabbyML/StarCoder-1B";
    };

    acceleration = lib.mkOption {
      type = types.enum ["cpu" "vulkan" "sycl"];
      default = "cpu";
    };

    settings = lib.mkOption {
      inherit (format) type;
      default = {
        model.completion.local.model_id = cfg.model;
        model.chat.local.model_id = cfg.chatModel;
      };
    };

    usageCollection = lib.mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      etc."tabby/config.toml".source = format.generate "config.toml" cfg.settings;
      systemPackages = [tabbyPackage];
    };

    systemd.services.tabby = {
      wantedBy = ["multi-user.target"];
      description = "Self-hosted AI coding assistant using large language models";
      after = ["network.target"];
      environment =
        {
          TABBY_ROOT = "%S/tabby";
          TABBY_DISABLE_USAGE_COLLECTION =
            if !cfg.usageCollection
            then "1"
            else "0";
        }
        // lib.optionalAttrs (cfg.acceleration == "sycl") {
          ZES_ENABLE_SYSMAN = "1";
        };
      preStart = "cp -f /etc/tabby/config.toml \${TABBY_ROOT}/config.toml";
      serviceConfig = {
        WorkingDirectory = "/var/lib/tabby";
        StateDirectory = ["tabby"];
        ConfigurationDirectory = ["tabby"];
        DynamicUser = true;
        User = "tabby";
        Group = "tabby";
        ExecStart = "${lib.getExe tabbyPackage} serve --port ${toString cfg.port} --device ${tabbyPackage.featureDevice}";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [mordrag];
}
