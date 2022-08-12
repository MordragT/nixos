{ pkgs, config, lib, ... }:
{
  services.caddy = {
    enable = true;
    acmeCA = config.security.acme.defaults.server;
    # email = "connect.mordrag@gmx.de";
    extraConfig = ''
      web.localhost {
        respond "Hello, world!"         
      }        
    '';
  };
}
