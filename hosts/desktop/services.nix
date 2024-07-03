{pkgs, ...}: {
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
  # mordrag.services.step-ca.enable = true;
  # mordrag.services.forgejo.enable = true;
  # mordrag.services.harmonia.enable = true;
  # mordrag.services.llama = {
  #   enable = true;
  #   settings = {
  #     model = "/var/lib/llama-cpp/codegemma-2b-f16.gguf";
  #     gpu-layers = 32;
  #   };
  # };
  # mordrag.services.stalwart.enable = true;
  mordrag.services.tabby = {
    enable = true;
    package = pkgs.tabby;
    acceleration = "sycl";
    port = 8000;
    settings = {
      model.completion.local.model_id = "MordragT/DeepseekCoder-1.3B-Q5";
      model.chat.local.model_id = "MordragT/DeepseekCoder-1.3B-Instruct-Q6";
      # model.completion.http = {
      #   kind = "llama.cpp/completion";
      #   api_endpoint = "http://127.0.0.1:8030";
      #   prompt_template = "<PRE> {prefix} <SUF>{suffix} <MID>";
      # };
      # model.chat.http = {
      #   kind = "openai/chat";
      #   api_endpoint = "http://127.0.0.1:8030";
      # };
      # model.chat.http = {
      #   kind = "openai/chat";
      #   model_name = "gemini-1.5-flash-latest";
      #   api_endpoint = "https://generativelanguage.googleapis.com/v1beta/";
      #   api_key = "<secret-key>";
      # };
    };
  };
  # mordrag.services.vaultwarden.enable = true;

  services.flatpak.enable = true;
  # services.private-gpt.enable = true;
  services.tailscale.enable = true; # trayscale gui ?
  # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
  networking.firewall.checkReversePath = "loose";

  # services.tor.enable = true;
  services.udev.packages = with pkgs; [
    platformio-core
    # openocd # plugdev errors are polluting the logs
  ];
  services.xserver.wacom.enable = true;
}
