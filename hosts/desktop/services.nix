{
  config,
  ...
}:
{
  vaultix.secrets.cloudflare = {
    file = ./secrets/cloudflare.age;
    owner = config.users.users.caddy.name;
    group = config.users.groups.caddy.name;
  };

  mordrag = {
    services = {
      caddy = {
        enable = true;
        secretFile = config.vaultix.secrets.cloudflare.path;
      };
      # llama = {
      #   enable = true;
      #   port = 8080;
      #   settings = {
      #     gpu-layers = 33;
      #     model = "DeepseekCoder-6.7-Instruct-Q4.gguf";
      #   };
      # };
      printing.enable = true;
      qpad = {
        enable = true;
        port = 3000;
        openFirewall = true;
      };
    };
  };

  services = {
    flatpak.enable = true;
    tailscale = {
      enable = true; # trayscale gui ?
      extraSetFlags = [ "--operator=tom" ];
      permitCertUid = config.services.caddy.user;
    };
    xserver.wacom.enable = true;
  };
}
