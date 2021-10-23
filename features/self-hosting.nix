{ pkgs, config, lib, ... }:
{
  
  imports =
    [ 
      ./services/caddy.nix
      ./services/nextcloud.nix
    #   ./services/gitea.nix
      ./services/step-ca.nix
    #   ./services/mailserver.nix
    #   # ./services/roundcube.nix
    #   ./services/vaultwarden.nix
    ];
}