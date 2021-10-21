{ lib, config, home-manager, nur-community, ... }:
{   
  home-manager.users.root = { config, pkgs, ... }:
  let
    toml = pkgs.formats.toml {};
  in {
    home.username = "root";
    home.homeDirectory = "/root";
    home.stateVersion = "21.11";
    
    home.packages = with pkgs; [
      helix    
    ];
        
    xdg = {
      enable = true;    
      configFile = {
        "helix/config.toml".source =
          toml.generate "helix-conf" { theme = "gruvbox"; };    
      };
    };
  };
}