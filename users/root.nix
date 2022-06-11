{ pkgs, ... }:
{
  home.username = "root";
  home.homeDirectory = "/root";
  home.stateVersion = "22.11";
  
  home.packages = with pkgs; [
    helix    
  ];
      
  xdg = {
    enable = true;    
    configFile = let
      toml = pkgs.formats.toml {};
    in {
      "helix/config.toml".source =
        toml.generate "helix-conf" { theme = "gruvbox"; };    
    };
  };
}