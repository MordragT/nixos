{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mordrag.services.lemonade;

  backendPath = name: "/etc/lemonade/backends/${name}";

  backendLinks = {
    "lemonade/backends/llamacpp-vulkan".source = "${cfg.backends.llamaCpp}/bin/llama-server";
    "lemonade/backends/whispercpp-vulkan".source = "${cfg.backends.whisperCpp}/bin/whisper-server";
    "lemonade/backends/sdcpp-vulkan".source = "${cfg.backends.sdCpp}/bin/sd-server";
    "lemonade/backends/thinksound-vulkan".source = "${cfg.backends.thinkSound}/bin/ts-server";
    "lemonade/backends/trellis-vulkan".source = "${cfg.backends.trellis}/bin/trellis-server";
    "lemonade/backends/acestep-vulkan".source = "${cfg.backends.aceStep}/bin/ace-server";
    "lemonade/backends/openmoss-vulkan".source = "${cfg.backends.openMoss}/bin/moss-tts-server";
    "lemonade/backends/kokoro-cpu".source = "${cfg.backends.kokoro}/bin/koko";
  };

  defaults = {
    llamacpp = {
      vulkan_bin = backendPath "llamacpp-vulkan";
      args = "--flash-attn on";
    };
    whispercpp = {
      vulkan_bin = backendPath "whispercpp-vulkan";
    };
    sdcpp = {
      vulkan_bin = backendPath "sdcpp-vulkan";
    };
    thinksound = {
      vulkan_bin = backendPath "thinksound-vulkan";
    };
    trellis = {
      vulkan_bin = backendPath "trellis-vulkan";
    };
    acestep = {
      vulkan_bin = backendPath "acestep-vulkan";
    };
    openmoss = {
      vulkan_bin = backendPath "openmoss-vulkan";
    };
    kokoro = {
      cpu_bin = backendPath "kokoro-cpu";
    };
  }
  // cfg.settings;

  defaultsFile = (pkgs.formats.json { }).generate "lemonade-defaults.json" defaults;
in
{
  options.mordrag.services.lemonade = {
    enable = lib.mkEnableOption "the Lemonade local AI server";

    port = lib.mkOption {
      type = lib.types.port;
      example = 13305;
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/lemonade";
    };

    settings = lib.mkOption {
      inherit (pkgs.formats.json { }) type;
      default = { };
    };

    backends = {
      llamaCpp = lib.mkOption {
        type = lib.types.package;
        default = pkgs.llama-cpp-vulkan;
      };

      whisperCpp = lib.mkOption {
        type = lib.types.package;
        default = pkgs.whisper-cpp-vulkan;
      };

      sdCpp = lib.mkOption {
        type = lib.types.package;
        default = pkgs.stable-diffusion-cpp-vulkan;
      };

      thinkSound = lib.mkOption {
        type = lib.types.package;
        default = pkgs.thinksound-cpp-vulkan;
      };

      trellis = lib.mkOption {
        type = lib.types.package;
        default = pkgs.trellis-cpp-vulkan;
      };

      aceStep = lib.mkOption {
        type = lib.types.package;
        default = pkgs.acestep-cpp-vulkan;
      };

      openMoss = lib.mkOption {
        type = lib.types.package;
        default = pkgs.openmoss-vulkan;
      };

      kokoro = lib.mkOption {
        type = lib.types.package;
        default = pkgs.kokoros;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users.lemonade = {
        isSystemUser = true;
        group = "lemonade";
        extraGroups = [
          "render"
          "video"
        ];
      };
      groups.lemonade = { };
    };

    mordrag.state.directories = [
      {
        directory = cfg.stateDir;
        user = "lemonade";
        group = "lemonade";
      }
    ];

    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0750 lemonade lemonade -"
      "d ${cfg.stateDir}/hf 0750 lemonade lemonade -"
      "d ${cfg.stateDir}/lemonade 0750 lemonade lemonade -"
    ];

    environment = {
      etc = backendLinks;

      systemPackages = [
        pkgs.lemonade-server
        cfg.backends.thinkSound
        cfg.backends.trellis
        cfg.backends.aceStep
        cfg.backends.openMoss
      ];

      sessionVariables = {
        LEMONADE_DEFAULTS_PATH = defaultsFile;
      };
    };

    systemd.services.lemonade = {
      description = "Lemonade AI server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        HOME = cfg.stateDir;
        HF_HOME = "${cfg.stateDir}/hf";
        LEMONADE_DEFAULTS_PATH = defaultsFile;
      };

      serviceConfig = {
        Type = "simple";
        User = "lemonade";
        Group = "lemonade";
        WorkingDirectory = cfg.stateDir;
        RuntimeDirectory = "lemonade";
        ExecStart = "${pkgs.lemonade-server}/bin/lemond --host ${cfg.host} --port ${toString cfg.port}";
        Restart = "on-failure";
        RestartSec = 5;
        KillSignal = "SIGINT";
        LimitMEMLOCK = "infinity";
      };
    };
  };
}
