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
    image = "ghcr.io/dusk-labs/dim:dev";
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
  
  systemd.services.init-taskcafe-network = {
    description = "Create network bridge for taskcafe and its postgres db";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig.Type = "oneshot";
    script = let dockercli = "${config.virtualisation.docker.package}/bin/docker";
      in ''
        # Put a true at the end to prevent getting non-zero return code, which will
        # crash the whole service
        check=$(${dockercli} network ls | grep "taskcafe" || true)
        if [ -z "$check" ]; then
          ${dockercli} network create taskcafe
        else
          echo "taskcafe already exists in docker"
        fi
      '';
  };
  
  virtualisation.oci-containers.containers."taskcafe" = {
    image = "taskcafe/taskcafe";
    ports = [
      "3333:3333/tcp"
      "3333:3333/udp"
    ];
    environment = {
      TASKCAFE_DATABASE_HOST = "postgres";
      TASKCAFE_MIGRATE = "true";
    };
    dependsOn = [ "postgres" ];
    volumes = [
      "/home/tom/.local/share/taskcafe:/root/uploads"
    ];
    extraOptions = [
      "--network=taskcafe"
      # "--net=host"
    ];
  };
    
  virtualisation.oci-containers.containers."postgres" = {
    image = "postgres";
    environment = {
      POSTGRES_USER = "taskcafe";
      POSTGRES_PASSWORD = "taskcafe_test";
      POSTGRES_DB = "taskcafe";    
    };
    volumes = [
      "/home/tom/.local/share/postgres:/var/lib/postgresql/data"
    ];
    extraOptions = [
      "--network=taskcafe"
      # "--net=host"
    ];
  };
}