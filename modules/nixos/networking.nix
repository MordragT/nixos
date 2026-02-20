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
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        plugins = with pkgs; [ networkmanager-openvpn ];
      };

      nameservers = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
      ];

      nftables.enable = true;

      firewall = {
        enable = true;
        # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
        checkReversePath = "loose";
      };

      bridges = {
        br0 = {
          interfaces = [ ];
        };
      };

      interfaces = {
        br0 = {
          ipv4.addresses = [
            {
              address = "10.10.0.1";
              prefixLength = 24;
            }
          ];
        };
      };

      nat = {
        enable = true;
        externalInterface = "enp35s0";
        internalInterfaces = [ "br0" ];
      };
    };

    systemd.services.NetworkManager-wait-online.enable = false;

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
      allow all
    '';
  };
}
