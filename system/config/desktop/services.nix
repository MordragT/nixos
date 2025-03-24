{
  pkgs,
  lib,
  ...
}: {
  mordrag.services.invokeai = {
    enable = true;
    settings = {
      device = "xpu";
      precision = "bfloat16";
      lazy_offload = true;
      log_memory_usage = true;
      log_level = "info";
      # ram = 7.5;
      # vram = 0.5;
      attention_type = "sliced";
      attention_slice_size = 4;
      sequential_guidance = true;
      force_tiled_decode = false;
    };
  };
  mordrag.services.printing.enable = true;
  mordrag.services.step-ca.enable = true;
  # mordrag.services.gitlab.enable = true;
  # mordrag.services.forgejo.enable = true;
  mordrag.services.harmonia.enable = true;
  # mordrag.services.stalwart.enable = true;
  # mordrag.services.tabby = {
  #   enable = true;
  #   package = pkgs.tabby;
  #   port = 8000;
  #   settings = {
  #     # model.completion.local.model_id = "MordragT/DeepseekCoder-1.3B-Q5";
  #     # model.chat.local.model_id = "MordragT/DeepseekCoder-1.3B-Instruct-Q6";
  #     model.completion.http = {
  #       kind = "ollama/completion";
  #       api_endpoint = "http://127.0.0.1:11434";
  #       model_name = "gemma2:9b-instruct-q4_K_S";
  #       prompt_template = "<fim_prefix>{prefix}<fim_suffix>{suffix}<fim_middle>";
  #     };
  #     model.chat.http = {
  #       kind = "openai/chat";
  #       api_endpoint = "http://127.0.0.1:11434/v1";
  #       model_name = "gemma2:9b-instruct-q4_K_S";
  #     };
  #     model.embedding.http = {
  #       kind = "ollama/embedding";
  #       api_endpoint = "http://127.0.0.1:11434";
  #       model_name = "mxbai-embed-large";
  #     };
  #   };
  # };
  # mordrag.services.vaultwarden.enable = true;
  mordrag.services.wg-quick.enable = true;

  # services.flatpak.enable = true;
  # services.ollama = {
  #   enable = true;
  #   package = pkgs.ollama-sycl;
  #   environmentVariables = {
  #     OLLAMA_INTEL_GPU = "1";
  #     # OLLAMA_DEBUG = "1";
  #     OLLAMA_MAX_LOADED_MODELS = "2";
  #     ZES_ENABLE_SYSMAN = "1";
  #   };
  #   loadModels = [
  #     # "deepseek-coder:6.7b-instruct-q3_K_S"
  #     # "gemma2:2b-instruct-q6_K"
  #     # "gemma2:9b-instruct-q4_K_S"
  #     # "codeqwen:7b-chat-v1.5-q4_K_S"
  #     # "nomic-embed-text"
  #     # "mxbai-embed-large"
  #   ];
  # };
  # systemd.services.ollama.serviceConfig.MemoryDenyWriteExecute = lib.mkForce false;

  services.tailscale.enable = true; # trayscale gui ?
  # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
  networking.firewall.checkReversePath = "loose";

  # services.tor.enable = true;
  # services.udev.packages = with pkgs; [
  #   platformio-core
  #   # openocd # plugdev errors are polluting the logs
  # ];
  services.xserver.wacom.enable = true;
}
