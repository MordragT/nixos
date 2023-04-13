{ ... }:
{
  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host = {
    enable = true;
    enableHardening = false;
  };


  # workaround for https://github.com/NixOS/nixpkgs/issues/59219#issuecomment-774711048
  # environment.variables = {
  #   QEMU_OPTS = ''-net nic,model=virtio,macaddr=$(cat /sys/class/net/macvtap0/address)
  #     -net tap,fd=3 3<>/dev/tap$(cat /sys/class/net/macvtap0/ifindex)'';
  # };

  # virtualisation.qemu.networkOptions = [
  #   "nic,model=virtio,macaddr=$(cat /sys/class/net/macvtap0/address)"
  #   "tap,fd=3 3<>/dev/tap$(cat /sys/class/net/macvtap0/ifindex)"
  # ];
}
