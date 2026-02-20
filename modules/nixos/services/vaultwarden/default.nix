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
    ca = lib.mkOption {
      description = "Certificate Authority";
      default = "https://ca.local:8443/acme/acme/directory";
      type = lib.types.nonEmptyStr;
    };
    fqdn = lib.mkOption {
      description = "Domain";
      default = "vault.local";
      type = lib.types.nonEmptyStr;
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://${cfg.fqdn}";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = cfg.port;
      };
    };

    services.caddy.enable = true;
    services.caddy.virtualHosts."${cfg.fqdn}".extraConfig = ''
      tls {
        ca ${cfg.ca}
        ca_root ${../step-ca/root_ca.crt}
      }

      reverse_proxy :${toString cfg.port}
    '';

    services.valhali.enable = true;
    services.valhali.services.vaultwarden = {
      alias = cfg.fqdn;
      kind = "https";
      port = 443;
    };

    networking.firewall.allowedTCPPorts = [ 443 ];
  };
}
