{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.services.forgejo;

  domain = "fogejo.${config.networking.domain}";
in
{
  options.mordrag.services.forgejo = {
    enable = lib.mkEnableOption "Forgejo";

    port = lib.mkOption {
      description = "Forgejo HTTP Port";
      type = lib.types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag.state.directories = [ config.services.forgejo.stateDir ];

    services = {
      forgejo = {
        enable = true;
        database.type = "sqlite3";
        settings.server = {
          DOMAIN = "https://${domain}";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = cfg.port;
        };
      };

      caddy = {
        virtualHosts.${domain}.extraConfig = ''
          import cloudflare
          reverse_proxy :${toString cfg.port}
        '';
      };
    };
  };
}
