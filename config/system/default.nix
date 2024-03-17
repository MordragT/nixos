{pkgs, ...}: {
  imports = [
    ./bluetooth.nix
    ./boot.nix
    ./fonts.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./pipewire.nix
    ./users.nix
  ];

  classified.keys.first = "/var/key";
  classified.files.pia.encrypted = ../../secrets/pia/pia.enc;

  environment.interactiveShellInit = ''
    alias comojit='comoji commit'
  '';

  environment.variables = {
    EDITOR = "hx";
  };

  environment.shells = [pkgs.nushellFull];

  # environment.sessionVariables = {
  #   PATH = "\${HOME}/.cargo/bin";
  #   XDG_CONFIG_HOME = "\${HOME}/.config";
  #   XDG_CACHE_HOME = "\${HOME}/.cache";
  #   #XDG_CACHE_HOME = "/run/user/1000/.cache";
  #   XDG_DATA_HOME = "\${HOME}/.local/share";
  #   XDG_STATE_HOME = "\${HOME}/.local/state";
  #   XDG_BIN_HOME = "\${HOME}/.local/bin";
  # };

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

  # This module contains mostly alternatives to POSIX utilities
  environment.systemPackages = with pkgs; [
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
  ];
}
