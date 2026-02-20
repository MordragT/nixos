{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mordrag.core;
in {
  options.mordrag.core = {
    enable = lib.mkEnableOption "Core";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      variables.EDITOR = "hx";
      shells = [pkgs.nushell];

      # This module contains mostly alternatives to POSIX utilities
      # , aswell as core utilities
      systemPackages = with pkgs; [
        alsa-utils # configure audio devices
        bintools
        clinfo # opencl info
        doggo # dig alternative
        drm_info
        dua # print file size of directories
        fd # find replacement
        helix # Kakoune style editor
        bottom # better top
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
  };
}
