{pkgs, ...}: {
  mordrag.services.comfyui = {
    enable = false;
    extraArgs = "--verbose";
    # extraArgs = "--use-pytorch-cross-attention --highvram --force-fp16 --bf16-vae --bf16-unet";
    # extraArgs = "--multi-user";
    # extraArgs = "--disable-ipex-optimize";
    package = pkgs.comfyui-xpu;
  };
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
  # mordrag.services.llama.enable = true;
  # mordrag.services.stalwart.enable = true;
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
