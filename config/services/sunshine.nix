{master, ...}: {
  systemd.user.services.sunshine = {
    enable = true;
    description = "sunshine";
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${master.sunshine}/bin/sunshine";
    };
  };

  # for sunshine
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';

  networking.firewall.allowedTCPPorts = [47984 47989 47990 48010];
  networking.firewall.allowedUDPPorts = [47998 47999 48000];

  boot.kernelModules = ["uinput"];
}
