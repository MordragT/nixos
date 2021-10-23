{ config, pkgs, lib, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };
  
  time.timeZone = "Europe/Berlin";
    
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  security.acme.email = "connect.mordrag@gmx.de";
  security.acme.acceptTerms = true;
    
  users.users = {
    tom = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
     
    root = {
      extraGroups = [ "root" ];
    };
  };
  
  environment.variables = {
    EDITOR = "hx";
  };
}