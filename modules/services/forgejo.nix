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
    ca = lib.mkOption {
      description = "Certificate Authority";
      default = "https://tom-desktop.local:8443/acme/acme/directory";
      type = lib.types.nonEmptyStr;
    };
    fqdn = lib.mkOption {
      description = "Domain";
      default = "git.local";
      type = lib.types.nonEmptyStr;
    };
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      database.type = "sqlite3";
      settings.server = {
        DOMAIN = "https://${cfg.fqdn}";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = cfg.port;
      };
    };

    services.caddy.enable = true;
    services.caddy.virtualHosts."${cfg.fqdn}".extraConfig = ''
      tls {
        ca ${cfg.ca}
        ca_root ${../../certs/root_ca.crt}
      }

      reverse_proxy :${toString cfg.port}
    '';

    services.valhali.enable = true;
    services.valhali.services.forgejo = {
      alias = cfg.fqdn;
      kind = "https";
      port = 443;
    };
  };
}
