{ pkgs, config, lib, ... }:
{
  services.nginx.enable = false;
  
  services.caddy = {
    enable = true;
    ca = config.security.acme.server;
    # email = "connect.mordrag@gmx.de";
    config = ''
      web.localhost {
        tls connect.mordrag@gmx.de {
          ca https://localhost:8443/acme/acme/directory
        }
        respond "Hello, world!"         
      }        
    '';    
  };
}