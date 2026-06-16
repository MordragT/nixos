{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mordrag.networking;
in
{
  options.mordrag.networking = {
    enable = lib.mkEnableOption "Networking";

    primary = lib.mkOption {
      description = "Options regarding the primary interface";
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "The name of the interface.";
            type = lib.types.str;
          };

          mac = lib.mkOption {
            description = "Define a MAC address for the interface.";
            type = lib.types.str;
            example = "ab:cd:ef:12:34:56";
          };
        };
      };
    };

    secondary = lib.mkOption {
      description = "Options regarding the primary interface";
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            name = lib.mkOption {
              description = "The name of the interface.";
              type = lib.types.str;
            };

            mac = lib.mkOption {
              description = "Define a MAC address for the interface.";
              type = lib.types.str;
              example = "ab:cd:ef:12:34:56";
            };
          };
        }
      );
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag = {
      state.directories = [ "/etc/NetworkManager/system-connections" ];
      users.main.extraGroups = [ "networkmanager" ];
    };

    networking = {
      useDHCP = false;
      nftables.enable = true;
      firewall.enable = true;
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };

      nameservers = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
      ];

      nat = {
        enable = true;
        enableIPv6 = true;
        externalInterface = cfg.primary.name;
        internalInterfaces = [ "bridge" ];
      };
    };

    systemd = {
      services.NetworkManager-wait-online.enable = false;

      network = {
        enable = true;
        wait-online.enable = false;

        # Each link must have a number smaller than 99
        # to be matched before the default `99-default.link`
        links = {
          "10-primary" = {
            matchConfig.PermanentMACAddress = cfg.primary.mac;
            linkConfig.Name = cfg.primary.name;
          };
        }
        // (lib.optionalAttrs (cfg.secondary != null) {
          "20-secondary" = {
            matchConfig.PermanentMACAddress = cfg.secondary.mac;
            linkConfig.Name = cfg.secondary.name;
          };
        });

        netdevs.bridge.netdevConfig = {
          Kind = "bridge";
          Name = "bridge";
        };

        networks.brdige = {
          matchConfig.Name = "bridge";
          networkConfig = {
            DHCPServer = true;
            IPv6SendRA = true;
            IPv6AcceptRA = false;
          };
          addresses = [
            {
              Address = "192.168.100.1/24";
            }
          ];
          dhcpServerConfig = {
            UplinkInterface = cfg.primary.name;
            # PoolOffset = 10;
            # PoolSize = 245;
            DefaultLeaseTimeSec = 1 * 60 * 60; # default 1h
            MaxLeaseTimeSec = 12 * 60 * 60; # default 12h
            EmitDNS = true;
          };
        };
      };
    };

    services = {
      resolved = {
        enable = true;
        settings = {
          Resolve = {
            LLMNR = false;
            MulticastDNS = false;
            DNSStubListener = true;
            DNSSEC = "allow-downgrade";
            DNSOverTLS = true;
          };
        };
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        nssmdns6 = false;
        openFirewall = true;
        publish = {
          enable = true;
          domain = true;
          addresses = true;
          workstation = true;
          userServices = true;
        };
      };
    };

    security.wrappers.qemu-bridge-helper = {
      source = "${pkgs.qemu-utils}/libexec/qemu-bridge-helper";
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+ep";
    };

    environment.etc."qemu/bridge.conf".text = ''
      allow ${cfg.primary.name}
    '';
  };
}
