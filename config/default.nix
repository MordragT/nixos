{pkgs, ...}: {
  imports = [
    ./bluetooth.nix
    ./fonts.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./pipewire.nix
    ./secrets.nix
    ./security.nix
    ./users.nix
  ];

  environment = {
    # interactiveShellInit = ''
    #   alias comojit='comoji commit'
    # '';
    variables.EDITOR = "hx";
    shells = [pkgs.nushellFull];

    # This module contains mostly alternatives to POSIX utilities
    # , aswell as core utilities
    systemPackages = with pkgs; [
      alsa-utils # configure audio devices
      clinfo # opencl info
      dua # print file size of directories
      fd # find replacement
      helix # Kakoune style editor
      htop # better top
      hwloc
      inetutils
      just # make alike
      libva-utils
      parted
      pciutils
      psmisc
      tealdeer # tldr
      tokei # count lines of code
      trash-cli # put files in trash
      usbutils
      vulkan-tools
    ];
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
