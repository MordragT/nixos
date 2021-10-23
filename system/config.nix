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
  # security.pam.p11.enable = true;

  environment.variables = {
    EDITOR = "hx";
  };
  
  # Users    
  users.users = {
    tom = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
     
    root = {
      extraGroups = [ "root" ];
    };
  };
}