{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.services.nextcloud;
  # caddy = config.services.caddy;
in {
  options.mordrag.services.nextcloud = {
    enable = lib.mkEnableOption "Nextcloud";
  };

  config = lib.mkIf cfg.enable {
    classified.files.nextcloud = {
      encrypted = ./nextcloud.enc;
      mode = "0440";
      user = "nextcloud";
      group = "nextcloud";
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;
      hostName = "nextcloud.localhost";
      https = true;
      settings = {
        # loglevel = 0;
        trusted_domains = [
          "bitwarden.localhost"
          "git.localhost"
        ];
        # overwriteprotocol = "https";
        default_phone_region = "DE";
      };
      config = {
        dbtype = "sqlite";
        adminuser = "root";
        adminpassFile = "/var/secrets/nextcloud";
      };
    };

    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };

    # services.phpfpm.pools.nextcloud.settings = {
    #   "listen.owner" = caddy.user;
    #   "listen.group" = caddy.group;
    # };

    # users.users.nextcloud = {
    #   group = "nextcloud";
    #   isSystemUser = true;
    # };
    # users.groups.nextcloud.members = ["nextcloud" config.services.caddy.user];

    # services.nginx.enable = false;
    # services.caddy.enable = true;
    # services.caddy.virtualHosts."nextcloud.localhost" = {
    #   extraConfig = ''
    #     root /store-apps/* ${config.services.nextcloud.home}
    #     root * ${config.services.nextcloud.package}
    #     php_fastcgi unix/${config.services.phpfpm.pools.nextcloud.socket}
    #     file_server

    #     header {
    #       Strict-Transport-Security max-age=1578000;
    #     }

    #     redir /.well-known/carddav /remote.php/dav 301
    #     redir /.well-known/caldav /remote.php/dav 301

    #     rewrite / /index.php

    #     @forbidden {
    #       path /.htaccess
    #       path /data/*
    #       path /config/*
    #       path /db_structure
    #       path /.xml
    #       path /README
    #       path /3rdparty/*
    #       path /lib/*
    #       path /templates/*
    #       path /occ
    #       path /console.php
    #     }
    #   '';
    # };
  };
}
