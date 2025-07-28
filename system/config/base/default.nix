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
}
