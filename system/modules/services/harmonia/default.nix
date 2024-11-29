{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.harmonia;
in {
  options.mordrag.services.harmonia = {
    enable = lib.mkEnableOption "Harmonia";
    port = lib.mkOption {
      description = "Harmonia HTTP Port";
      default = 8020;
      type = lib.types.port;
    };
    ca = lib.mkOption {
      description = "Certificate Authority";
      default = "https://ca.local:8443/acme/acme/directory";
      type = lib.types.nonEmptyStr;
    };
    fqdn = lib.mkOption {
      description = "Domain";
      default = "store.local";
      type = lib.types.nonEmptyStr;
    };
  };

  config = lib.mkIf cfg.enable {
    classified.files.harmonia.encrypted = ./harmonia.enc;

    services.harmonia = {
      enable = true;
      # nix-store --generate-binary-cache-key ${cfg.fqdn} harmonia.secret harmonia.pub
      signKeyPaths = ["/var/secrets/harmonia"];
      settings = {
        bind = "127.0.0.1:${toString cfg.port}";
      };
    };

    services.caddy.enable = true;
    services.caddy.virtualHosts."${cfg.fqdn}".extraConfig = ''
      tls {
        ca ${cfg.ca}
        ca_root ${../step-ca/root_ca.crt}
      }

      encode zstd

      reverse_proxy :${toString cfg.port}
    '';

    services.valhali.enable = true;
    services.valhali.services.harmonia = {
      alias = cfg.fqdn;
      kind = "https";
      port = 443;
    };

    networking.firewall.allowedTCPPorts = [443 80];
  };
}
