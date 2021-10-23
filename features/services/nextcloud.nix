{ pkgs, config, lib, ... }:
let
  caddy = config.services.caddy;
  secrets = config.age.secrets;
  
  secret = path: {
    file = path;
    owner = "nextcloud";
    group = "nextcloud";
    mode = "0440";
  };
in {
  age.secrets.nextcloud = secret ../../secrets/nextcloud.age;
    
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
      adminpassFile = secrets.nextcloud.path;
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
  users.groups.nextcloud.members = [ "nextcloud" config.services.caddy.user ];

  services.caddy.virtualHosts."nextcloud.localhost" = {
    extraConfig = ''
      root /store-apps/* ${config.services.nextcloud.home}
      root * ${config.services.nextcloud.package}
      php_fastcgi unix/${config.services.phpfpm.pools.nextcloud.socket}
      # {
      #   env PATH ${config.services.phpfpm.pools.nextcloud.phpEnv.PATH}
      # }
      file_server
        
      #rewrite /index.php/* /index.php?{query}
                      
      header {
        Strict-Transport-Security max-age=1578000;
        #X-Frame-Options allow-from https://localhost/;
        #X-Content-Security-Policy frame-ancestors https://*.localhost/;
        #Content-Security-Policy frame-ancestors https://*.localhost/;
      }
        
      log {
        output file /var/log/caddy/nextcloud.log
        format single_field common_log
      }
        
      # client support  
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
        
      tls connect.mordrag@gmx.de {
        ca https://localhost:8443/acme/acme/directory
      }
    '';          
  };
}
