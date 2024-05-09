{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.vaultwarden;
in {
  options.mordrag.services.vaultwarden = {
    enable = lib.mkEnableOption "Vaultwarden";
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://bitwarden.localhost";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
      };
    };

    services.caddy.enable = true;
    services.caddy.virtualHosts."bitwarden.localhost".extraConfig = ''
      reverse_proxy :8222
    '';
  };
}
