{pkgs, ...}: {
  imports = [
    ./secrets
    ./bluetooth.nix
    ./fonts.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./pipewire.nix
    ./security.nix
    ./users.nix
  ];

  environment = {
    variables.EDITOR = "hx";
    shells = [pkgs.nushell];

    # This module contains mostly alternatives to POSIX utilities
    # , aswell as core utilities
    systemPackages = with pkgs; [
      alsa-utils # configure audio devices
      bintools
      clinfo # opencl info
      drm_info
      dua # print file size of directories
      fd # find replacement
      helix # Kakoune style editor
      btop # better top
      hwloc
      inetutils
      just # make alike
      libva-utils
      lm_sensors
      parted
      pax-utils
      pciutils
      psmisc
      tealdeer # tldr
      tokei # count lines of code
      trash-cli # put files in trash
      usbutils
      vulkan-tools
      v4l-utils
    ];
  };

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
}
