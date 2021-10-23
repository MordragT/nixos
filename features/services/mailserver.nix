{ pkgs, config, lib, ... }:
{
  imports =
    [ 
      # Mailserver  
      (fetchTarball {  
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/5675b122a947b40e551438df6a623efad19fd2e7/nixos-mailserver-5675b122a947b40e551438df6a623efad19fd2e7.tar.gz";
        sha256 = "1fwhb7a5v9c98nzhf3dyqf3a5ianqh7k50zizj8v5nmj3blxw4pi";
      })
    ];
  
  mailserver = {
    enable = true;
    fqdn = "mailserver.localhost";
    domains = [ "mailserver.localhost" ];
    
    # create certificates via own acme server
    certificateScheme = 1;
    certificateDirectory = "/var/secrets/mailserver";
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