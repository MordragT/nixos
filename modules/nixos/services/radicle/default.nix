{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.services.radicle;

  radicle-explorer' = pkgs.radicle-explorer.withConfig {
    preferredSeeds = [
      {
        hostname = cfg.seed;
        port = 443;
        scheme = "https";
      }
    ];
  };
in {
  options.mordrag.services.radicle = {
    enable = lib.mkEnableOption "Radicle";

    explorer = lib.mkOption {
      description = "Explorer domain";
      default = "radicle.mordrag.de";
      type = lib.types.nonEmptyStr;
    };

    seed = lib.mkOption {
      description = "Seed domain";
      default = "seed.mordrag.de";
      type = lib.types.nonEmptyStr;
    };

    # nodePort = lib.mkOption {
    #   description = "Radicle HTTP Port";
    #   default = 8776;
    #   type = lib.types.port;
    # };

    # port = lib.mkOption {
    #   description = "Radicle HTTP Port";
    #   default = 8040;
    #   type = lib.types.port;
    # };
  };

  config = lib.mkIf cfg.enable {
    # classified.files.radicle.encrypted = ./radicle.enc;

    # services.radicle = {
    #   enable = true;
    #   privateKeyFile = "/var/secrets/radicle";
    #   publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpNbe209ZFzpPOnCW/lCSBmCCvz4Zgb7i3u6akOLKKS";
    #   node = {
    #     openFirewall = true;
    #     listenPort = cfg.nodePort;
    #   };

    #   httpd = {
    #     enable = true;
    #     listenPort = cfg.port;
    #   };

    #   settings = {
    #     cli.hints = true;

    #     node = {
    #       alias = "mordrag";
    #       seedingPolicy.default = "block";
    #     };

    #     preferredSeeds = [
    #       "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@iris.radicle.xyz:8776"
    #       "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@rosa.radicle.xyz:8776"
    #     ];

    #     publicExplorer = "https://app.radicle.xyz/nodes/$host/$rid$path";

    #     web = {
    #       # avatarUrl = "";
    #       # bannerUrl = "";
    #       # description = "";

    #       pinned.repositories = [];
    #     };
    #   };
    # };

    mordrag.services.caddy.enable = true;
    services.caddy.virtualHosts."${cfg.explorer}".extraConfig = ''
      root * ${radicle-explorer'}
      encode zstd gzip
      try_files {path} /index.html
      file_server
    '';

    # TODO the port is hardcoded from the systemd user service
    services.caddy.virtualHosts."${cfg.seed}".extraConfig = ''
      import cloudflare
      reverse_proxy :8080
    '';
  };
}
