{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.services.caddy;
in {
  options.mordrag.services.caddy = {
    enable = lib.mkEnableOption "Caddy server";
  };

  config = lib.mkIf cfg.enable {
    # has to contain `export CLOUDFLARE_API_TOKEN=<token>
    # Profile -> API Tokens -> Create Token
    classified.files.cloudflare.encrypted = ./cloudflare.enc;

    services.caddy = {
      enable = true;
      environmentFile = "/var/secrets/cloudflare";
      extraConfig = ''
        (cloudflare) {
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
          }
        }
      '';
      package = pkgs.caddy.withPlugins {
        plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
        hash = "sha256-ea8PC/+SlPRdEVVF/I3c1CBprlVp1nrumKM5cMwJJ3U=";
      };
    };

    networking.firewall.allowedTCPPorts = [443 80];
  };
}
