{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.forgejo;
in {
  options.mordrag.services.forgejo = {
    enable = lib.mkEnableOption "Forgejo";
    port = lib.mkOption {
      description = "Forgejo HTTP Port";
      default = 8030;
      type = lib.types.port;
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      database.type = "sqlite3";
      settings.server = {
        # DOMAIN = "https://${config.networking.fqdn}/git";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = cfg.port;
      };
    };

    mordrag.services.caddy.enable = true;
    mordrag.services.caddy.services.git = "reverse_proxy :${toString cfg.port}";
  };
}
