{ pkgs, config, lib, ... }:
{
  services.gitea = {
    enable = true;
    database.type = "sqlite3";
    domain = "localhost";
    rootUrl = "http://localhost:3000/";
    httpAddress = "0.0.0.0";
    httpPort = 3000;
  };

  services.caddy.virtualHosts."git.localhost" = {
    extraConfig = ''          
      tls connect.mordrag@gmx.de {
        ca https://localhost:8443/acme/acme/directory
      }
      reverse_proxy http://localhost:3000 {
        #header_down Content-Security-Policy "frame-ancestors https://nextcloud.localhost/"
      }
    '';
  };
}
