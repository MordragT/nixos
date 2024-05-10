{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.caddy;
in {
  options.mordrag.services.caddy = {
    enable = lib.mkEnableOption "Caddy";
    services = lib.mkOption {
      description = "Caddy services";
      default = {};
      type = lib.types.attrsOf lib.types.str;
    };
    ca = lib.mkOption {
      description = "Certificate Authority";
      default = "https://tom-desktop.local:8443/acme/acme/directory";
      type = lib.types.str;
    };
    port = lib.mkOption {
      description = "Vaultwarden HTTPS Port";
      default = 443;
      type = lib.types.port;
    };
  };

  config = let
    fqdn = "${config.networking.fqdn}";
    convert-service = {
      name,
      value,
    }: ''
      handle /${name} {
        ${value}
      }
    '';
    services = lib.concatMapStrings convert-service (lib.attrsToList cfg.services);
  in
    lib.mkIf cfg.enable {
      services.caddy.enable = true;
      services.caddy.virtualHosts."${fqdn}".extraConfig = ''
        tls {
          ca ${cfg.ca}
          ca_root ${../../certs/root_ca.crt}
        }

        ${services}
      '';

      environment.etc."systemd/dnssd/https.dnssd".text = ''
        [Service]
        Name=Web %H
        Type=_https._tcp
        Port=${toString cfg.port}
      '';

      networking.firewall.allowedTCPPorts = [cfg.port];
    };
}
