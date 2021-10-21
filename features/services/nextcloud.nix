{ pkgs, config, lib, ... }:
{
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
      adminpassFile = "/etc/nixos/secrets/nextcloud-admin-pass";
      extraTrustedDomains = [
        "nextcloud.localhost"
        "git.localhost"
      ];
      overwriteProtocol = "https";
    };    
  };
  
  phpfpm.pools.nextcloud.settings = {
    "listen.owner" = config.services.caddy.user;
    "listen.group" = config.services.caddy.group;    
  };
  users.groups.nextcloud.members = [ "nextcloud" config.services.caddy.user ];
}
