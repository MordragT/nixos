{
  config,
  pkgs,
  ...
}: {
  mordrag.services.invokeai = {
    enable = false;
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
  mordrag.services.radicle.enable = true;
  # mordrag.services.forgejo.enable = true;
  mordrag.services.harmonia.enable = true;
  mordrag.services.llama = {
    enable = true;
    settings = {
      model = "DeepseekCoder-6.7-Instruct-Q4.gguf";
      gpu-layers = 33;
    };
  };
  # mordrag.services.stalwart.enable = true;
  # mordrag.services.vaultwarden.enable = true;
  mordrag.services.wg-quick.enable = true;

  services.espanso = {
    enable = false;
    package = pkgs.espanso-wayland;
  };
  services.flatpak.enable = true;
  services.tailscale = {
    enable = true; # trayscale gui ?
    extraSetFlags = [
      "--operator=tom"
    ];
    permitCertUid = config.services.caddy.user;
  };

  # services.tor.enable = true;
  # services.udev.packages = with pkgs; [
  #   platformio-core
  #   # openocd # plugdev errors are polluting the logs
  # ];
  services.xserver.wacom.enable = true;
}
