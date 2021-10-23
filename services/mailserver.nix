{ pkgs, config, lib, ... }:
{ 
  mailserver = {
    enable = true;
    fqdn = "mailserver.localhost";
    domains = [ "mailserver.localhost" ];
    
    # specify certificate location
    certificateScheme = 1;
    # certificateDirectory = "/var/secrets/mailserver";
    certificateFile = "/var/lib/caddy/.local/share/caddy/certificates/localhost-8443-acme-acme-directory/mailserver.localhost/mailserver.localhost.crt";
    keyFile = "/var/lib/caddy/.local/share/caddy/certificates/localhost-8443-acme-acme-directory/mailserver.localhost/mailserver.localhost.key";
    
    loginAccounts = {
      "netzag@mailserver.localhost" = {
        hashedPassword = "$2y$05$9B8sjfGE4uXbPab3dOz7YeuXK3Lje.rAR.ev.iiqlLUsB7D80Ld4q";    
      };    
      "druckerag@mailserver.localhost" = {
        hashedPassword = "$2y$05$9B8sjfGE4uXbPab3dOz7YeuXK3Lje.rAR.ev.iiqlLUsB7D80Ld4q";    
      };    
    };    
  };
    
  services.caddy.virtualHosts."mailserver.localhost" = {
    extraConfig = ''
      tls connect.mordrag@gmx.de {
        ca https://localhost:8443/acme/acme/directory
      }
    '';          
  };
}