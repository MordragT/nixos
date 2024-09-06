{...}: {
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    connectionConfig."connection.mdns" = 1;
    connectionConfig."connection.llmnr" = 0;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  # systemd.network.wait-online.anyInterface = true;
  # systemd.network.wait-online.timeout = 5;
  services.resolved = {
    enable = true;
    llmnr = "false";
    extraConfig = ''
      MulticastDNS=false
      DNSStubListener=false
    '';
  };

  networking.firewall.enable = true;

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
