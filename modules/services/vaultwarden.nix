{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.vaultwarden;
in {
  options.mordrag.services.vaultwarden = {
    enable = lib.mkEnableOption "Vaultwarden";
    port = lib.mkOption {
      description = "Vaultwarden HTTP Port";
      default = 8080;
      type = lib.types.port;
    };
    ca = lib.mkOption {
      description = "Certificate Authority";
      default = "https://tom-desktop.local:8443/acme/acme/directory";
      type = lib.types.str;
    };
  };

  config = let
    fqdn = "vault.local";
  in
    lib.mkIf cfg.enable {
      services.vaultwarden = {
        enable = true;
        config = {
          DOMAIN = "https://${fqdn}";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = cfg.port;
        };
      };

      # mordrag.services.caddy.enable = true;
      # mordrag.services.caddy.services.vault = "reverse_proxy :${toString cfg.port}";

      services.caddy.enable = true;
      services.caddy.virtualHosts."${fqdn}".extraConfig = ''
        tls {
          ca ${cfg.ca}
          ca_root ${../../certs/root_ca.crt}
        }

        reverse_proxy :${toString cfg.port}
      '';

      # environment.etc."systemd/dnssd/vault.dnssd".text = ''
      #   [Service]
      #   Name=vault
      #   Type=_https._tcp
      #   Port=${toString cfg.port}
      # '';
    };
}
