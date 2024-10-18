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
    # interactiveShellInit = ''
    #   alias comojit='comoji commit'
    # '';
    variables.EDITOR = "hx";
    shells = [pkgs.nushell];

    # This module contains mostly alternatives to POSIX utilities
    # , aswell as core utilities
    systemPackages = with pkgs; [
      alsa-utils # configure audio devices
      bintools
      clinfo # opencl info
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
    ];
  };

  # xdg.mime = {
  #   enable = true;
  #   defaultApplications = {
  #     "text/html" = "firefox.desktop";
  #     "x-scheme-handler/http" = "firefox.desktop";
  #     "x-scheme-handler/https" = "firefox.desktop";
  #     "x-scheme-handler/about" = "firefox.desktop";
  #     "x-scheme-handler/unknown" = "firefox.desktop";
  #   };
  # };
}
