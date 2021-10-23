{ pkgs, config, lib, ... }:
{
  services.roundcube = {
    enable = true;
    hostName = "roundcube.localhost";    
  };
}
