{pkgs, ...}: {
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    plugins = with pkgs; [networkmanager-openvpn];
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  # systemd.network.wait-online.anyInterface = true;
  # systemd.network.wait-online.timeout = 5;

  # https://developers.cloudflare.com/1.1.1.1/ip-addresses/
  # last digit determines:
  # 1 = default
  # 2 = block malware
  # 3 = block malware + adult content
  networking.nameservers = [
    "1.1.1.1#cloudflare-dns.com"
    "1.0.0.1#cloudflare-dns.com"
    "2606:4700:4700::1111#cloudflare-dns.com"
    "2606:4700:4700::1001#cloudflare-dns.com"
  ];

  services.resolved = {
    enable = true;

    settings.Resolve = {
      LLMNR = false;
      MulticastDNS = false;
      DNSStubListener = true;
      DNSSEC = "allow-downgrade";
      DNSOverTLS = true;
    };
  };

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;

    # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
    checkReversePath = "loose";
  };

  # Bridge Lab interface (br0) for VMs and Containers
  # Can be used nicely togehter with qemu-bridge-helper
  networking.bridges.br0.interfaces = [];
  networking.interfaces.br0.ipv4.addresses = [
    {
      address = "10.10.0.1";
      prefixLength = 24;
    }
  ];

  # Setup NAT from the bridge to the external interface
  networking.nat = {
    enable = true;
    externalInterface = "enp35s0";
    internalInterfaces = ["br0"];
  };

  # Source: https://github.com/microvm-nix/microvm.nix/blob/f5c1bbfd4cf686ec1822ccaeb634a8b93ee5120f/nixos-modules/host/default.nix
  # This helper creates tap interfaces and attaches them to a bridge
  # for qemu regardless if it is run as root or not.
  security.wrappers.qemu-bridge-helper = {
    source = "${pkgs.qemu-utils}/libexec/qemu-bridge-helper";
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin+ep";
  };

  # You must define this file with your bridge interfaces if you
  # intend to use qemu-bridge-helper through a `type = "bridge"`
  # interface.
  environment.etc."qemu/bridge.conf".text = ''
    allow all
  '';

  services.avahi = {
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
}
