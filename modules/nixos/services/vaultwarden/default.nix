{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.services.vaultwarden;
in
{
  options.mordrag.services.vaultwarden = {
    enable = lib.mkEnableOption "Vaultwarden";
    port = lib.mkOption {
      description = "Vaultwarden HTTP Port";
      default = 8060;
      type = lib.types.port;
    };
    fqdn = lib.mkOption {
      description = "Domain";
      default = "vault.mordrag.de";
      type = lib.types.nonEmptyStr;
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag.services.caddy.enable = true;

    services = {
      vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://${cfg.fqdn}";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = cfg.port;
        };
      };

      caddy = {
        virtualHosts = {
          "${cfg.fqdn}" = {
            extraConfig = ''
              import cloudflare
              reverse_proxy :${toString cfg.port}
            '';
          };
        };
      };
    };
  };
}
