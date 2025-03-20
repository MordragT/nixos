{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.gitlab;
in {
  options.mordrag.services.gitlab = {
    enable = lib.mkEnableOption "Gitlab";
    port = lib.mkOption {
      description = "Gitlab HTTP Port";
      default = 8010;
      type = lib.types.port;
    };
    ca = lib.mkOption {
      description = "Certificate Authority";
      default = "https://ca.local:8443/acme/acme/directory";
      type = lib.types.nonEmptyStr;
    };
    fqdn = lib.mkOption {
      description = "Domain";
      default = "git.local";
      type = lib.types.nonEmptyStr;
    };
  };

  config = lib.mkIf cfg.enable {
    services.gitlab = {
      inherit (cfg) port;
      enable = true;
      databasePasswordFile = pkgs.writeText "dbPassword" "zgvcyfwsxzcwr85l";
      initialRootPasswordFile = pkgs.writeText "rootPassword" "dakqdvp4ovhksxer";
      secrets = {
        secretFile = pkgs.writeText "secret" "Aig5zaic";
        otpFile = pkgs.writeText "otpsecret" "Riew9mue";
        dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
        jwsFile = pkgs.runCommand "oidcKeyBase" {} "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
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
    services.valhali.services.gitlab = {
      alias = cfg.fqdn;
      kind = "https";
      port = 443;
    };

    networking.firewall.allowedTCPPorts = [443];
  };
}
