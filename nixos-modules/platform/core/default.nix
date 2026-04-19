{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mordrag.platform.core;
in
{
  options.mordrag.platform.core = {
    enable = lib.mkEnableOption "Core";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      variables.EDITOR = "${pkgs.helix}/bin/hx";
      shells = [ pkgs.nushell ];

      # This module contains mostly alternatives to POSIX utilities
      # , aswell as core utilities
      systemPackages = with pkgs; [
        config.boot.kernelPackages.turbostat
        alsa-utils # configure audio devices
        asciinema_3 # record terminals
        bintools
        btop
        clinfo # opencl info
        doggo # dig alternative
        dmidecode
        drm_info
        dua # print file size of directories
        fd # find replacement
        helix # Kakoune style editor
        bottom # better top
        hwloc
        imagemagick
        inetutils
        just # make alike
        libva-utils
        lm_sensors
        lshw
        lsof # list open files
        macchina # neofetch alternative
        parted
        pax-utils
        pciutils
        psmisc
        powerstat
        tealdeer # tldr
        tokei # count lines of code
        trash-cli # put files in trash
        usbutils
        vulkan-tools
        v4l-utils
      ];
    };
  };
}
