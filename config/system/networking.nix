{...}: {
  networking.firewall.enable = true;

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  # systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.anyInterface = true;
  systemd.network.wait-online.timeout = 5;
  services.resolved.enable = true;
}
