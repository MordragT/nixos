{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.services.llama;

  settings = {
    hf-repo = "unsloth/Qwen3.5-9B-GGUF:UD-IQ3_XXS";
    # hf-repo = "bartowski/Meta-Llama-3-8B-Instruct-GGUF:Q4_K_M";
    sleep-idle-seconds = 5 * 60;

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
