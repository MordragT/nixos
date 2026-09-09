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
    # cpu-moe = true;
    # load-mode = "none";

    cache-type-k = "q8_0";
    cache-type-v = "q4_0";
    flash-attn = "on";

    inherit (cfg) port;
  };
in
{
  options.mordrag.services.llama = {
    enable = lib.mkEnableOption "Llama";

    port = lib.mkOption {
      description = "LLaMA C++ HTTP Port";
      type = lib.types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag.state.directories = [ "/var/lib/llama-cpp" ];

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
        WorkingDirectory = "/var/lib/llama-cpp";

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
