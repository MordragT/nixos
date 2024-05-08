{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.vaultwarden;
in {
  options = {
    mordrag.vaultwarden = {
      enable = lib.mkEnableOption "Vaultwarden";
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        domain = "https://bitwarden.localhost";
        rocketPort = 3030;
      };
    };

    services.caddy.virtualHosts."bitwarden.localhost" = {
      extraConfig = ''
        tls connect.mordrag@gmx.de {
          ca https://localhost:8443/acme/acme/directory
        }
        reverse_proxy http://localhost:3030
      '';
    };
  };
}
