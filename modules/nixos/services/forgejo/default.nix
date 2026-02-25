{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.services.forgejo;
in
{
  options.mordrag.services.forgejo = {
    enable = lib.mkEnableOption "Forgejo";
    port = lib.mkOption {
      description = "Forgejo HTTP Port";
      default = 8010;
      type = lib.types.port;
    };
    fqdn = lib.mkOption {
      description = "Domain";
      default = "git.mordrag.de";
      type = lib.types.nonEmptyStr;
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag.services.caddy.enable = true;

    services = {
      forgejo = {
        enable = true;
        database.type = "sqlite3";
        settings.server = {
          DOMAIN = "https://${cfg.fqdn}";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = cfg.port;
        };
      };

      caddy = {
        virtualHosts."${cfg.fqdn}".extraConfig = ''
          import cloudflare
          reverse_proxy :${toString cfg.port}
        '';
      };
    };
  };
}
