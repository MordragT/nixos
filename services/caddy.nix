{ pkgs, config, lib, ... }:
{  
  services.caddy = {
    enable = true;
    acmeCA = config.security.acme.defaults.server;
    # email = "connect.mordrag@gmx.de";
    extraConfig = ''
      web.localhost {
        tls connect.mordrag@gmx.de {
          ca https://localhost:8443/acme/acme/directory
        }
        respond "Hello, world!"         
      }        
    '';    
  };
}
