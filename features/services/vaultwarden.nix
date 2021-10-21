{ pkgs, config, lib, ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      domain = "https://bitwarden.localhost";    
      rocketPort = 3030;
    };    
  };
}
