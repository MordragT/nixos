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

    lanMac = lib.mkOption {
      description = "Define a MAC address for the LAN interface.";
      type = lib.types.str;
      example = "ab:cd:ef:12:34:56";
    };

    wlanMac = lib.mkOption {
      description = "Define a MAC address for the WLAN interface.";
      type = lib.types.str;
      example = "ab:cd:ef:12:34:56";
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag.state.directories = [ "/etc/NetworkManager/system-connections" ];

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
        externalInterface = "lan";
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
          "10-lan" = {
            matchConfig.PermanentMACAddress = cfg.lanMac;
            linkConfig.Name = "lan";
          };

          "20-wlan" = {
            matchConfig.PermanentMACAddress = cfg.wlanMac;
            linkConfig.Name = "wlan";
          };
        };

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
            UplinkInterface = "lan";
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
      allow lan
    '';
  };
}
