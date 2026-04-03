{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.services.vaultwarden;

  domain = "vaultwarden.${config.networking.domain}";
in
{
  options.mordrag.services.vaultwarden = {
    enable = lib.mkEnableOption "Vaultwarden";

    port = lib.mkOption {
      description = "Vaultwarden HTTP Port";
      type = lib.types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://${domain}";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = cfg.port;
        };
      };

      caddy.virtualHosts.${domain}.extraConfig = ''
        import cloudflare
        reverse_proxy :${toString cfg.port}
      '';
    };
  };
}
