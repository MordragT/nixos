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
    systemPackages = with pkgs; [
      # Rust Tools
      helix # Kakoune style editor
      bottom # htop alike
      tealdeer # tldr
      tokei # count lines of code
      freshfetch # neofetch alternative
      grex # create regular expressions
      hyperfine # benchmarking
      gping # ping with a graph
      sd # sed and awk replacement using regex
      fd # find replacement
      pueue # send commands into queue to execute
      nomino # batch renaming
      ouch # (de)compressor with sane interface
      ripgrep # grep alternative
      procs # modern ps replacement
      hurl # like curl but better
      dua # print file size of directories

      alsa-utils # configure audio devices
      brightnessctl
      htop # better top
      cpufetch # fetch cpu information
      clinfo # opencl info
      vulkan-tools
      mesa-demos
      ventoy # create bootable usb drive for isos
      trash-cli # put files in trash
      expect # automate interactive applications
      usbutils
      pciutils
      inetutils
      libva-utils
      psmisc
      xorg.xlsclients
      hwloc
      parted
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
