{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.services.llama;

  settings = {

    # hf-repo = "unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q2_K_XL";
    # cpu-moe = true;
    # load-mode = "none";

    # hf-repo = "unsloth/Qwen3.5-9B-GGUF:Q4_K_M";
    # hf-repo = "ornith-ai/Ornith-1.5-9B-GGUF:Q4_K_M";
    # hf-repo = "JetBrains/Mellum2-12B-A2.5B-Thinking-GGUF-MXFP4_MOE:MXFP4_MOE";
    hf-repo = "Myric/Mellum2-12B-A2.5B-Thinking-APEX-GGUF";
    hf-file = "Mellum2-12B-APEX-mini-imat.gguf";

    sleep-idle-seconds = 5 * 60;
    log-verbosity = 4;

    cache-type-k = "iq4_nl";
    cache-type-v = "iq4_nl";
    # no-kv-offload = true; # do not offload cache to gpu

    flash-attn = "on";

    inherit (cfg) port;
  }
  // lib.optionalAttrs (cfg.device != null) {
    inherit (cfg) device;
  };
in
{
  options.mordrag.services.llama = {
    enable = lib.mkEnableOption "Llama";

    port = lib.mkOption {
      description = "LLaMA C++ HTTP Port";
      type = lib.types.port;
    };

    device = lib.mkOption {
      description = "The device to run LLaMA.CPP on.";
      type = with lib.types; nullOr str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    # The service uses dynamic user, therefore `private`
    mordrag.state.directories = [
      {
        directory = "/var/lib/private/llama-cpp";
        mode = "0700";
      }
      {
        directory = "/var/cache/private/llama-cpp";
        mode = "0700";
      }
    ];

    systemd.services.llama-cpp = {
      description = "LLaMA C++ server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        ZES_ENABLE_SYSMAN = "1";
        # level-zero discovery has been changed and somehow doesn't work anymore
        # https://github.com/oneapi-src/level-zero/pull/402/files
        LD_LIBRARY_PATH = "/run/opengl-driver/lib/";
        LLAMA_CACHE = "/var/cache/llama-cpp";
      };
      serviceConfig = {
        Type = "idle";
        KillSignal = "SIGINT";
        Restart = "on-failure";
        RestartSec = 300;

        DynamicUser = true;
        StateDirectory = "llama-cpp";
        CacheDirectory = "llama-cpp";
        RuntimeDirectory = "llama-cpp";
        WorkingDirectory = "%t/llama-cpp";

        ExecStart = toString [
          (lib.getExe' pkgs.llama-cpp-sycl "llama-server")
          (lib.cli.toCommandLine (optionName: {
            option = if builtins.stringLength optionName > 1 then "--${optionName}" else "-${optionName}";
            sep = " ";
            explicitBool = false;
            formatArg = lib.generators.mkValueStringDefault { };
          }) settings)
        ];
      };
    };

    services = {
      # llama-cpp = {
      #   enable = true;
      #   package = pkgs.llama-cpp-vulkan;
      #   settings = settings;
      # };

      caddy.virtualHosts."llama.${config.networking.domain}".extraConfig = ''
        import cloudflare
        encode zstd
        reverse_proxy :${toString cfg.port}
      '';
    };
  };
}
