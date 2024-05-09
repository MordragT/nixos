{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.forgejo;
in {
  options.mordrag.services.forgejo = {
    enable = lib.mkEnableOption "Forgejo";
  };

  config = lib.mkIf cfg.enable {
    services.forgejo = {
      enable = true;
      database.type = "sqlite3";
      settings.server = {
        DOMAIN = "localhost";
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
      };
    };

    services.caddy.enable = true;
    services.caddy.virtualHosts."git.localhost".extraConfig = ''
      reverse_proxy 127.0.0.1:3000
    '';
  };
}
