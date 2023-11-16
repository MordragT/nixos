{...}: {
  networking.firewall.enable = true;

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  # systemd.services.NetworkManager-wait-online.enable = false;
  services.resolved.enable = true;
}
