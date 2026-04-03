{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.services.caddy;
in
{
  options.mordrag.services.caddy = {
    enable = lib.mkEnableOption "Caddy server";
  };

  config = lib.mkIf cfg.enable {
    # has to contain `export CLOUDFLARE_API_TOKEN=<token>
    # Profile -> API Tokens -> Create Token
    vaultix.secrets.cloudflare = {
      file = ./cloudflare.age;
      owner = config.users.users.caddy.name;
      group = config.users.groups.caddy.name;
    };

    services.caddy = {
      enable = true;
      environmentFile = config.vaultix.secrets.cloudflare.path;
      extraConfig = ''
        (cloudflare) {
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
        }
      '';
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
        hash = "sha256-7DGnojZvcQBZ6LEjT0e5O9gZgsvEeHlQP9aKaJIs/Zg=";
      };
    };

    networking.firewall.allowedTCPPorts = [
      443
      80
    ];
  };
}
