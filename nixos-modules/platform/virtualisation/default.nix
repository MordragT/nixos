{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.platform.virtualisation;

  qemuMacFromName =
    name:
    let
      # 12 hex chars from name
      h = builtins.hashString "md5" name;
      b1 = builtins.substring 0 2 h;
      b2 = builtins.substring 2 2 h;
      b3 = builtins.substring 4 2 h;
    in
    "52:54:00:${b1}:${b2}:${b3}";
in
{
  options.mordrag.platform.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.vmVariant = {
      boot.loader = {
        grub.enable = false;
        systemd-boot.enable = false;
      };

      services.qemuGuest.enable = true;

      systemd.network.networks."10-eth0" = {
        matchConfig.Name = "eth0";
        DHCP = true;
      };

      virtualisation = {
        diskSize = 4 * 1024;
        memorySize = 8 * 1024;
        cores = 4;
        graphics = true;

        qemu.networkingOptions = lib.mkIf config.mordrag.networking.enable lib.mkForce [
          "-netdev bridge,id=tap-server,br=bridge,helper=/run/wrappers/bin/qemu-bridge-helper"
          "-device virtio-net-pci,netdev=tap-server,mac=${qemuMacFromName config.networking.hostName}"
        ];
      };
    };

  };
}
