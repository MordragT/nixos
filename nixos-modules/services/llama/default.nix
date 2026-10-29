{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.services.llama;

  # pkg = pkgs.llama-cpp-sycl;
  # pkg = pkgs.llama-cpp-openvino;
  #   pkg = pkgs.llama-cpp-vulkan.overrideAttrs (prev: {
  #     src = pkgs.fetchFromGitHub {
  #       owner = "PrismML-Eng";
  #       repo = "llama.cpp";
  #       tag = "prism-b10772-e8fd209";
  #       hash = "sha256-0VnSQkILpKpj61GdGiM5JVcB3Z1NoJOGOtTOW/XWFSc=";
  #     };
  #
  #     npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
  #
  #     patches = [
  #       # vulkan: fuse the sign multiply into the Hadamard FWHT - #349
  #       (pkgs.fetchpatch2 {
  #         url = "https://github.com/PrismML-Eng/llama.cpp/pull/349.patch";
  #         hash = "sha256-sewGml341j5xhaIT9bUex+o/i2vOkc/U3lbxYwokCq8=";
  #       })
  #       # vulkan: extend PTQ1_0 fast integer-dot path to INTEL_XE1 iGPUs (Arrow Lake-H) - #274
  #       (pkgs.fetchpatch2 {
  #         url = "https://github.com/PrismML-Eng/llama.cpp/pull/274.patch";
  #         hash = "sha256-OLeqU76PpUCCUNYqNil9nAP4d2O3abqxZA2iabVAj2s=";
  #       })
  #     ];
  #
  #     cmakeFlags = (prev.cmakeFlags or [ ]) ++ [
  #       (lib.cmakeFeature "LLAMA_BUILD_NUMBER" "10772")
  #       (lib.cmakeFeature "LLAMA_BUILD_COMMIT" "e8fd209")
  #     ];
  #
  #     # test-dfly-fusion.cpp fails to link
  #     doCheck = false;
  #   });
  pkg = pkgs.llama-cpp-vulkan;

  settings = {
    # ------------------------------------------------------
    # hf-repo = "unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q2_K_XL";
    # cpu-moe = true;
    # load-mode = "none";

    # ------------------------------------------------------
    hf-repo = "Myric/Mellum2.1-12B-A2.5B-Thinking-APEX-GGUF";
    hf-file = "Mellum2.1-12B-A2.5B-Thinking-APEX-3.7bpw.gguf";
    spec-type = "ngram-map-k4v";
    spec-ngram-map-k4v-size-m = 12;

    # ------------------------------------------------------
    #     hf-repo = "prism-ml/Ternary-Bonsai-2-27B-gguf:TQ1_0";
    #
    #     no-mmproj = true; # do not load vision stuff to save memory
    #
    #     # Try to reduce compute buffer
    #     batch-size = 512;
    #     ubatch-size = 256;
    #     ctx-size = 4 * 1024;
    #     # spec-type = "ngram-simple";
    #     # spec-draft-n-max = 16;

    sleep-idle-seconds = 5 * 60;
    log-verbosity = 4;

    cache-type-k = "iq4_nl";
    cache-type-v = "iq4_nl";

    # no-kv-offload = true; # do not offload cache to gpu
    fit-target = 1024;

    parallel = 1;

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

    #     systemd.services.llama-cpp = {
    #       description = "LLaMA C++ server";
    #       after = [ "network.target" ];
    #       wantedBy = [ "multi-user.target" ];
    #       environment = {
    #         GGML_OPENVINO_DEVICE = "GPU";
    #         # GGML_OPENVINO_MOE_OP = "0";
    #         # GGML_OPENVINO_STATEFUL_EXECUTION = "1";
    #         ZES_ENABLE_SYSMAN = "1";
    #         LD_LIBRARY_PATH = "/run/opengl-driver/lib/";
    #         LLAMA_CACHE = "/var/cache/llama-cpp";
    #       };
    #       serviceConfig = {
    #         Type = "idle";
    #         KillSignal = "SIGINT";
    #         Restart = "on-failure";
    #         RestartSec = 300;
    #
    #         DynamicUser = true;
    #         StateDirectory = "llama-cpp";
    #         CacheDirectory = "llama-cpp";
    #         RuntimeDirectory = "llama-cpp";
    #         WorkingDirectory = "%t/llama-cpp";
    #
    #         ExecStart = toString [
    #           (lib.getExe' pkg "llama-server")
    #           (lib.cli.toCommandLine (optionName: {
    #             option = if builtins.stringLength optionName > 1 then "--${optionName}" else "-${optionName}";
    #             sep = " ";
    #             explicitBool = false;
    #             formatArg = lib.generators.mkValueStringDefault { };
    #           }) settings)
    #         ];
    #       };
    #     };

    services = {
      llama-cpp = {
        enable = true;
        package = pkg;
        inherit settings;
      };

      caddy.virtualHosts."llama.${config.networking.domain}".extraConfig = ''
        import cloudflare
        encode zstd
        reverse_proxy :${toString cfg.port}
      '';
    };
  };
}
