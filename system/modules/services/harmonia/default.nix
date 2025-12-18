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
    fqdn = lib.mkOption {
      description = "Domain";
      default = "harmonia.mordrag.de";
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

    mordrag.services.caddy.enable = true;
    services.caddy.virtualHosts."${cfg.fqdn}".extraConfig = ''
      import cloudflare
      encode zstd
      reverse_proxy :${toString cfg.port}
    '';
  };
}
