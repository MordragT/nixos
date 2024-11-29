{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.gnome-network-displays;
in {
  options.mordrag.programs.gnome-network-displays = {
    enable = lib.mkEnableOption "Gnome Disks";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.gnome-network-displays];

    networking.firewall.trustedInterfaces = ["p2p-wl+"];

    networking.firewall.allowedTCPPorts = [7236 7250]; # wifi direct port ?
  };
}
