{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.nextcloud;
  caddy = config.services.caddy;
in {
  options = {
    mordrag.nextcloud = {
      enable = lib.mkEnableOption "Nextcloud";
    };
  };

  config = lib.mkIf cfg.enable {
    classified.files.nextcloud = {
      encrypted = ../../secrets/nextcloud.enc;
      mode = "0440";
      user = "nextcloud";
      group = "nextcloud";
    };

    services.nextcloud = {
      enable = true;
      hostName = "nextcloud.localhost";
      logLevel = 0;
      https = true;
      config = {
        dbtype = "sqlite";
        defaultPhoneRegion = "DE";
        adminuser = "root";
        # Should use adminpassfile
        adminpassFile = "/var/secrets/nextcloud";
        extraTrustedDomains = [
          "nextcloud.localhost"
          "git.localhost"
        ];
        overwriteProtocol = "https";
      };
    };

    services.phpfpm.pools.nextcloud.settings = {
      "listen.owner" = caddy.user;
      "listen.group" = caddy.group;
    };

    users.users.nextcloud = {
      group = "nextcloud";
      isSystemUser = true;
    };
    users.groups.nextcloud.members = ["nextcloud" config.services.caddy.user];

    services.nginx.enable = false;
    services.caddy.enable = true;
    services.caddy.virtualHosts."nextcloud.localhost" = {
      extraConfig = ''
        root /store-apps/* ${config.services.nextcloud.home}
        root * ${config.services.nextcloud.package}
        php_fastcgi unix/${config.services.phpfpm.pools.nextcloud.socket}
        file_server

        header {
          Strict-Transport-Security max-age=1578000;
        }

        redir /.well-known/carddav /remote.php/dav 301
        redir /.well-known/caldav /remote.php/dav 301

        rewrite / /index.php

        @forbidden {
          path /.htaccess
          path /data/*
          path /config/*
          path /db_structure
          path /.xml
          path /README
          path /3rdparty/*
          path /lib/*
          path /templates/*
          path /occ
          path /console.php
        }
      '';
    };
  };
}
