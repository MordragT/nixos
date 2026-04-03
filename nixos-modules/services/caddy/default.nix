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

    secretFile = lib.mkOption {
      description = ''
        Caddy cloudflare secret has to contain `export CLOUDFLARE_API_TOKEN=<token>
        It can be created via: Profile -> API Tokens -> Create Token
      '';
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      openFirewall = true;
      environmentFile = cfg.secretFile;
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
  };
}
