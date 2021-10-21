{ pkgs, config, lib, ... }:
{
  services.caddy = {
    enable = true;
    ca = config.security.acme.server;
    # email = "connect.mordrag@gmx.de";
    virtualHosts = {
      # roundcube.localhost = {
      #   tls connect.mordrag@gmx.de {
      #     ca https://localhost:8443/acme/acme/directory
      #   }          
      # }
        
      "nextcloud.localhost" = {
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
        
      "mailserver.localhost" = {
        extraConfig = ''
          tls connect.mordrag@gmx.de {
            ca https://localhost:8443/acme/acme/directory
          }
        '';          
      };         
    };
    config = ''
      web.localhost {
        tls connect.mordrag@gmx.de {
          ca https://localhost:8443/acme/acme/directory
        }
        respond "Hello, world!"         
      }
        
      git.localhost {          
        tls connect.mordrag@gmx.de {
          ca https://localhost:8443/acme/acme/directory
        }
        reverse_proxy http://localhost:3000 {
          #header_down Content-Security-Policy "frame-ancestors https://nextcloud.localhost/"
        }
      }
        
      bitwarden.localhost {
        tls connect.mordrag@gmx.de {
          ca https://localhost:8443/acme/acme/directory
        }
        reverse_proxy http://localhost:3030
      }
    '';  
      
  };
}
