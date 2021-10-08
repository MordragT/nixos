# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  unstableTarball =
    fetchTarball
     https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  home-manager =
    fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz";
      sha256 = "1x77fglv81rrpihkv8vnl1023hawg83k42vbflp76blgljv1sxm7";
  };
in {
    
  disabledModules = [ 
    "services/web-servers/caddy.nix"
    #"services/web-apps/nextcloud.nix"
  ];
    
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
      (import "${unstableTarball}/nixos/modules/services/web-servers/caddy/default.nix")
      #(import "${unstableTarball}/nixos/modules/services/web-apps/nextcloud.nix")
      # Mailserver  
      (fetchTarball {  
        url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/5675b122a947b40e551438df6a623efad19fd2e7/nixos-mailserver-5675b122a947b40e551438df6a623efad19fd2e7.tar.gz";
        sha256 = "1fwhb7a5v9c98nzhf3dyqf3a5ianqh7k50zizj8v5nmj3blxw4pi";
      })
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  
  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  
  networking = {
        
    hostName = "tom-laptop"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp2s0.useDHCP = true;
    interfaces.wlo1.useDHCP = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    extraHosts = ''
      127.0.0.1 mordrag.io
    '';
  };
    # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "de";
   };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;
  #services.xserver.libinput.touchpad.tapping = true;
     
  # nix = {
  #   package = pkgs.nixFlakes;
  #   extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
  #     "experimental-features = nix-command flakes";
  # };


  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
    
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    unstable.helix  
    neovim
    step-cli
    firefox
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tom = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   };
      
  home-manager.users.tom = (import "/etc/nixos/home.nix");
    
  home-manager.users.root = { config, pkgs, ... }:
  let
    toml = pkgs.formats.toml {};
  in {
    home.username = "root";
    home.homeDirectory = "/root";
    home.stateVersion = "21.05";
    
    # home.packages = with pkgs; [
    #   unstable.helix    
    # ];
        
    xdg = {
      enable = true;    
      configFile = {
        "helix/config.toml".source =
          toml.generate "helix-conf" { theme = "gruvbox"; };    
      };
    };
  };
    
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  security.acme.server = "https://localhost:8443/acme/acme/directory";
  security.acme.email = "connect.mordrag@gmx.de";
  security.acme.acceptTerms = true;
        
   # List services that you want to enable:
  
  mailserver = {
    enable = true;
    fqdn = "mailserver.localhost";
    domains = [ "mailserver.localhost" ];
    
    # create certificates via own acme server
    certificateScheme = 1;
    certificateDirectory = "/var/secrets/mailserver";
    certificateFile = "/var/lib/caddy/.local/share/caddy/certificates/localhost-8443-acme-acme-directory/mailserver.localhost/mailserver.localhost.crt";
    keyFile = "/var/lib/caddy/.local/share/caddy/certificates/localhost-8443-acme-acme-directory/mailserver.localhost/mailserver.localhost.key";
    
    loginAccounts = {
      "netzag@mailserver.localhost" = {
        hashedPassword = "$2y$05$9B8sjfGE4uXbPab3dOz7YeuXK3Lje.rAR.ev.iiqlLUsB7D80Ld4q";    
      };    
      "druckerag@mailserver.localhost" = {
        hashedPassword = "$2y$05$9B8sjfGE4uXbPab3dOz7YeuXK3Lje.rAR.ev.iiqlLUsB7D80Ld4q";    
      };    
    };    
  };
    
  services = {
    step-ca = {
      enable = true;
      address = "127.0.0.1";
      port = 8443;    
      intermediatePasswordFile = "/var/secrets/step-ca/password";
      settings = {
        root = "/var/secrets/step-ca/root_ca.crt";
        crt = "/var/secrets/step-ca/intermediate_ca.crt";
        key = "/var/secrets/step-ca/intermediate_ca_key";
        dnsNames = [ "localhost" ];
        logger.format = "text";
        db = {
          type = "badgerV2";
          dataSource = "/var/lib/step-ca/db";    
        };
        authority.provisioners = [
          {
            type = "ACME";
            name = "acme";    
            
          }  
        ];
      };
    };
        
    gitea = {
      enable = true;
      database.type = "sqlite3";
      domain = "localhost";
      rootUrl = "http://localhost:3000/";
      httpAddress = "0.0.0.0";
      httpPort = 3000;
      settings = {
        # cors = {
        #   ENABLED = true;
        #   ALLOW_DOMAIN = "https://nextcloud.localhost/";    
        #   ALLOW_CREDENTIALS = true;
        #   X_FRAME_OPTIONS = "allow-from https://nextcloud.localhost";    
        # };    
      };
    };
        
    caddy = {
      enable = true;
      ca = config.security.acme.server;
      # email = "connect.mordrag@gmx.de";
      virtualHosts = {
        # roundcube.localhost = {
        #   tls connect.mordrag@gmx.de {
        #     ca https://localhost:8443/acme/acme/directory
        #   }          
        # }
          
        "nextcloud.localhost" = {
          extraConfig = ''
            root /store-apps/* ${config.services.nextcloud.home}
            root * ${config.services.nextcloud.package}
            php_fastcgi unix/${config.services.phpfpm.pools.nextcloud.socket}
            # {
            #   env PATH ${config.services.phpfpm.pools.nextcloud.phpEnv.PATH}
            # }
            file_server
              
            #rewrite /index.php/* /index.php?{query}
                            
            header {
              Strict-Transport-Security max-age=1578000;
              #X-Frame-Options allow-from https://localhost/;
              #X-Content-Security-Policy frame-ancestors https://*.localhost/;
              #Content-Security-Policy frame-ancestors https://*.localhost/;
            }
              
            log {
              output file /var/log/caddy/nextcloud.log
              format single_field common_log
            }
              
            # client support  
            redir /.well-known/carddav /remote.php/dav 301
            redir /.well-known/caldav /remote.php/dav 301
              
            rewrite / /index.php
              
            @forbidden {
              path /.htaccess
              path /data/*
              path /config/*
              path /db_structure
              path /.xml
              path /README
              path /3rdparty/*
              path /lib/*
              path /templates/*
              path /occ
              path /console.php
            }
              
            tls connect.mordrag@gmx.de {
              ca https://localhost:8443/acme/acme/directory
            }
          '';          
        };
          
        "mailserver.localhost" = {
          extraConfig = ''
            tls connect.mordrag@gmx.de {
              ca https://localhost:8443/acme/acme/directory
            }
          '';          
        };         
      };
      config = ''
        web.localhost {
          tls connect.mordrag@gmx.de {
            ca https://localhost:8443/acme/acme/directory
          }
          respond "Hello, world!"         
        }
          
        git.localhost {          
          tls connect.mordrag@gmx.de {
            ca https://localhost:8443/acme/acme/directory
          }
          reverse_proxy http://localhost:3000 {
            #header_down Content-Security-Policy "frame-ancestors https://nextcloud.localhost/"
          }
        }
          
        bitwarden.localhost {
          tls connect.mordrag@gmx.de {
            ca https://localhost:8443/acme/acme/directory
          }
          reverse_proxy http://localhost:3030
        }
      '';  
        
    };
        
    roundcube = {
      enable = false;
      hostName = "roundcube.localhost";    
    };
    
    # vaultwarden
    bitwarden_rs = {
      enable = true;
      config = {
        domain = "https://bitwarden.localhost";    
        rocketPort = 3030;
      };    
    };
         
    nginx.enable = false;
    nginx.virtualHosts = {
      "roundcube.localhost" = {
        #acmeRoot = "https://localhost:8443/acme/acme/directory";
        #forceSSL = true;
        #enableACME = true;
        #listen = [{ addr = "localhost"; port = 3030; }];
      };
      "nextcloud.localhost" = {
        #acmeRoot = "https://localhost:8443/acme/acme/directory";
        #forceSSL = true;
        #enableACME = true;
        #listen = [{ addr = "localhost"; port = 3333; }];    
      };    
      "mailserver.localhost" = {
        #serverName = "mailserver.localhost";
        #acmeRoot = "https://localhost:8443/acme/acme/directory";
        #enableACME = true;
        #forceSSL = true;
      };
    };
    
    nextcloud = {
      enable = true;
      hostName = "nextcloud.localhost";
      logLevel = 0;
      https = true;
      config = {
        dbtype = "sqlite";
        defaultPhoneRegion = "DE";
        adminuser = "root"; 
        # Should use adminpassfile
        adminpass = "madina";
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
  };     

  users.users.step-ca = {
    extraGroups = [ "secrets" ];
    isSystemUser = true;    
  };
      
  users.groups.step-ca = { };
  users.groups.secrets.name = "secrets";
  users.groups.nextcloud.members = [ "nextcloud" config.services.caddy.user ];
    
  systemd.tmpfiles.rules = [
    "d /var/secrets 750 root secrets"    
    "z /var/secrets 750 root secrets"
    "d /var/lib/step-ca 700 step-ca step-ca"    
    "z /var/lib/step-ca 700 step-ca step-ca"    
    "d /var/log/caddy 750 caddy caddy"
    "z /var/log/caddy 750 caddy caddy"
  ];
          
  systemd.services."step-ca" = {
    serviceConfig = {
      WorkingDirectory = lib.mkForce "/var/lib/step-ca";
      Environment = lib.mkForce "Home=/var/lib/step-ca";
      User = "step-ca";
      Group = "step-ca";
      DynamicUser = lib.mkForce false;
      # SystemCallArchitectures = "native";
      # SystemCallFilter = [
      #   "@system-service"
      #   "~@privileged"
      #   "~@chown"
      #   "~@aio"
      #   "~@resources"
      # ];    
    };    
  };

  security.pki.certificateFiles = [
    /var/secrets/step-ca/root_ca.crt
    /var/secrets/step-ca/intermediate_ca.crt    
  ];
     # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

