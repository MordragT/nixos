{
  config,
  ...
}:
{
  mordrag = {
    services = {
      # harmonia.enable = true;
      invokeai = {
        enable = false;
        settings = {
          attention_slice_size = 4;
          attention_type = "sliced";
          device = "xpu";
          force_tiled_decode = false;
          lazy_offload = true;
          log_level = "info";
          log_memory_usage = true;
          precision = "bfloat16";
          sequential_guidance = true;
          # ram = 7.5;
          # vram = 0.5;
        };
      };
      llama = {
        enable = true;
        settings = {
          gpu-layers = 33;
          model = "DeepseekCoder-6.7-Instruct-Q4.gguf";
        };
      };
      printing.enable = true;
      radicle.enable = true;
      # forgejo.enable = true;
      # stalwart.enable = true;
      # vaultwarden.enable = true;
      wg-quick.enable = true;
    };
  };

  services = {
    flatpak.enable = true;
    tailscale = {
      enable = true; # trayscale gui ?
      extraSetFlags = [
        "--operator=tom"
      ];
      permitCertUid = config.services.caddy.user;
    };
    xserver.wacom.enable = true;
  };
}
