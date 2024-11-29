{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.services.wg-quick;
in {
  options.mordrag.services.wg-quick = {
    enable = lib.mkEnableOption "WG Quick Interfaces";
    proton = lib.mkEnableOption "Proton VPN";
    pia = lib.mkEnableOption "Pia VPN";
  };

  config = lib.mkIf cfg.enable {
    # Expires December 2025
    classified.files."proton-nl".encrypted = ./proton-nl.enc;

    networking.wg-quick.interfaces.proton-nl = {
      privateKeyFile = "/var/secrets/proton-nl";
      address = ["10.2.0.2/32"];
      dns = ["10.2.0.1"];
      mtu = 1280;
      autostart = cfg.proton;

      # killswitch
      postUp = let
        interface = "proton-nl";
      in ''
        nft "add chain ip wg-quick-${interface} output { type filter hook output priority 0; }"
        nft "add rule ip wg-quick-${interface} output oifname != \"${interface}\" mark != $(wg show ${interface} fwmark) fib daddr type != local counter reject"
      '';

      peers = [
        {
          publicKey = "BMVFYo1dYKoCWl6QJzrGjWzRxQVD5ZQ3D4/L331J52s=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "169.150.218.31:51820";
        }
      ];
    };

    classified.files."pia-de".encrypted = ./pia-de.enc;

    networking.wg-quick.interfaces.pia-de = {
      privateKeyFile = "/var/secrets/pia-de";
      address = ["10.36.142.120"];
      dns = ["10.0.0.243"];
      mtu = 1280;
      autostart = cfg.pia;

      # killswitch
      postUp = let
        interface = "pia-de";
      in ''
        nft "add chain ip wg-quick-${interface} output { type filter hook output priority 0; }"
        nft "add rule ip wg-quick-${interface} output oifname != \"${interface}\" mark != $(wg show ${interface} fwmark) fib daddr type != local counter reject"
      '';

      peers = [
        {
          publicKey = "+kvca+CNmakeXb8qqgTrbcZ4fal1HVr7/qKOJD3Qz30=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "216.24.216.211:1337";
        }
      ];
    };
  };
}
