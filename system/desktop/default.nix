{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp2s0";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  networking = {
    hostName = "tom-pc";
    useDHCP = false;
    useNetworkd = true;

    extraHosts = ''
      127.0.0.1 mordrag.io
    '';

    # nat = {
    #   enable = true;
    #   enableIPv6 = false;
    #   internalInterfaces = [ "virbr0" ];
    #   externalInterface = "eth0";
    # };
  };
  systemd.services."systemd-networkd-wait-online".enable = false;

  systemd.network = {


    netdevs.macvtap0 = {
      netdevConfig = {
        Kind = "macvtap";
        Name = "macvtap0";
        MACAddress = "02:00:00:00:00:01";
      };
      extraConfig = ''
        [MACVTAP]
        Mode=bridge
      '';
    };

    # networks.macvtap-net0 = {
    #   matchConfig.Name = "macvtap0";
    #   address = [ "192.168.1.80/32" ];
    #   gateway = [ "192.168.1.0" ];
    #   dns = [ "192.168.1.1" ];
    # };

    networks.enp5s0-net = {
      matchConfig.Name = "enp5s0";
      macvlan = [ "macvlan0" ];
      extraConfig = ''
        MACVTAP=macvtap0
      '';
      DHCP = "yes";
      # address = [ "192.168.1.156/32" ];
      # gateway = [ "192.168.1.0" ];
      # dns = [ "192.168.1.1" ];
    };

    # links.macvtap-link = {
    #   matchConfig.Path = "pci-0000:05:00.0";
    #   linkConfig.Name = "macvtap-vm-net";
    # };

    # networks.macvtap-vm-net = {
    #   matchConfig.Name = "vm-a1";
    #   extraConfig = ''
    #     MACVTAP=macvtap0
    #   '';
    #   # address = [ "192.168.1.80/32" ];
    #   # gateway = [ "192.168.1.0" ];
    #   # dns = [ "192.168.1.1" ];
    # };

    netdevs.macvlan0 = {
      netdevConfig = {
        Kind = "macvlan";
        Name = "macvlan0";
      };
      macvlanConfig.Mode = "bridge";
    };

    # networks.macvlan-net0 = {
    #   matchConfig.Name = "macvlan0";
    #   address = [ "192.168.1.156/24" ];
    #   gateway = [ "192.168.1.0" ];
    #   dns = [ "208.67.222.123" "208.67.220.123" "192.168.1.1" ];
    # };

    # networks.macvlan-enp5s0-net = {
    #   matchConfig.Name = "enp5s0";
    #   macvlan = [ "macvlan0" ];
    # };

    # -------------------

    # netdevs.macvlan0 = {
    #   netdevConfig = {
    #     Kind = "macvlan";
    #     Name = "macvlan0";
    #   };
    #   macvlanConfig.Mode = "bridge";
    # };

    # networks.macvlan-net0 = {
    #   matchConfig.Name = "macvlan0";
    #   address = [ "192.168.1.0/24" ];
    #   gateway = [ "192.168.1.0" ];
    #   dns = [ "192.168.1.1" ];
    # };

    # networks.macvlan-vm-net = {
    #   matchConfig.Name = "vm-*";
    #   macvlan = [ "macvlan0" ];
    # };

    # networks.macvlan-enp5s0-net = {
    #   matchConfig.Name = "enp5s0";
    #   macvlan = [ "macvlan0" ];
    # };

    # -----------------

    # netdevs.macvtap0 = {
    #   netdevConfig = {
    #     #Kind = "bridge";
    #     #Name = "virbr0";
    #     Kind = "macvtap";
    #     Name = "macvtap0";
    #   };
    #   extraConfig = ''
    #     [MACVTAP]
    #     Mode=bridge
    #   '';
    # };
    # links.macvtap0 = {
    #   matchConfig.Name = "macvtap0";
    #   linkConfig.MACAddress = "02:00:00:00:00:01";
    # };
    # networks.vm-eth0 = {
    #   matchConfig.Name = "vm-*";
    #   extraConfig = ''
    #     MACVTAP=macvtap0
    #   '';
    # };

    # ----------------

    # networks.virbr0 = {
    #   matchConfig.Name = "virbr0";
    #   # addresses = [{
    #   #   addressConfig.Address = "192.168.240.0/24";
    #   # }];
    #   #bridge = [ "virbr0" ];
    #   address = [ "192.168.240.0/24" ];
    #   #gateway = [ "192.168.1.0" ];
    #   #dns = [ "192.168.1.1" ];
    #   # ipv6SendRAConfig = {
    #   #   EmitDNS = true;
    #   #   Managed = true;
    #   #   OtherInformation = true;
    #   # };
    # };
    # networks.vm-eth0 = {
    #   matchConfig.Name = "vm-*";
    #   networkConfig.Bridge = "virbr0";
    # };
  };
}
