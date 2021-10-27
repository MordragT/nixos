{ config, pkgs, lib, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  time.timeZone = "Europe/Berlin";
    
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Fira Code";
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
      extraGroups = [ "wheel" "docker" ];
    };
     
    root = {
      extraGroups = [ "root" ];
    };
  };
  
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira
      fira-code
      jetbrains-mono
      roboto
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Fira Code" ];
      serif = [ "Noto Serif" ];
      sansSerif = [ "Fira Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
  
  virtualisation.docker.enable = true;
  
  # TODO docker images in own services nix files
  
  virtualisation.oci-containers.containers."dim" = {
    image = "vgarleanu/dim";
    ports = [
       "8000:8000/tcp"   
    ];
    volumes = [
      "/home/tom/.config/dim:/opt/dim/config"
      "/home/tom/Videos:/media"
    ];
    autoStart = false;
  };
    
  virtualisation.oci-containers.containers."minecraft" = {
    image = "minecraftservers/minecraft-server";
    ports = [
      "25565:25565/tcp"
      "25565:25565/udp"
    ];
    environment = {
      EULA = "TRUE";
    };
    autoStart = false;
  };
}