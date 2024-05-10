{...}: {
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
    connectionConfig."connection.mdns" = 2;
    connectionConfig."connection.llmnr" = 0;
  };
  # systemd.services.NetworkManager-wait-online.enable = false;
  # systemd.network.wait-online.anyInterface = true;
  # systemd.network.wait-online.timeout = 5;
  services.resolved = {
    enable = true;
    llmnr = "false";
    extraConfig = ''
      MulticastDNS=true
      DNSStubListener=true
    '';
  };

  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [5353];
  networking.domain = "local";
  # networking.hosts = {
  #   "tom-desktop.local" = ["vault.tom-desktop.local"];
  # };

  # services.caddy = {
  #   enable = true;
  #   acmeCA = null;
  #   logFormat = ''
  #     level DEBUG
  #   '';
  #   globalConfig = ''
  #     acme_ca https://tom-desktop.local:8443/acme/acme/directory
  #     acme_ca_root ${../certs/root_ca.crt}
  #   '';
  # };

  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   openFirewall = true;
  #   publish = {
  #     enable = true;
  #     domain = true;
  #     addresses = true;
  #     workstation = true;
  #     userServices = true;
  #   };
  # };
}
