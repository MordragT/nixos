{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.virtualisation;
in
{
  options.mordrag.virtualisation = {
    enable = lib.mkEnableOption "Virtualisation";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.vmVariant = {
      services.qemuGuest.enable = true;
      # services.spice-vdagentd.enable = true;

      virtualisation = {
        diskSize = 4 * 1024;
        memorySize = 8 * 1024;
        cores = 4;

        qemu.options = [
          #"-M q35"
          "-vga none"
          "-device virtio-vga-gl,hostmem=8G,blob=on,venus=on"
          "-object memory-backend-memfd,id=mem1,size=8G"
          "-machine memory-backend=mem1"
          "-display gtk,gl=on,show-cursor=on"
          # "-display sdl,gl=on"
          # "-audio driver=pipewire,model=virtio"
        ];
      };
    };
  };
}
