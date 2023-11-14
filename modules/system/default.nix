{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./pipewire.nix
    ./users.nix
  ];

  environment.interactiveShellInit = ''
    alias comojit='comoji commit'
  '';

  environment.sessionVariables = {
    PATH = "\${HOME}/.cargo/bin";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_CACHE_HOME = "\${HOME}/.cache";
    #XDG_CACHE_HOME = "/run/user/1000/.cache";
    XDG_DATA_HOME = "\${HOME}/.local/share";
    XDG_STATE_HOME = "\${HOME}/.local/state";
    XDG_BIN_HOME = "\${HOME}/.local/bin";
  };

  environment.shells = [pkgs.nushell];

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
    htop # better top
    cpufetch # fetch cpu information
    ventoy # create bootable usb drive for isos
    trash-cli # put files in trash
    expect # automate interactive applications
    usbutils
    pciutils
    inetutils
    psmisc
    openconnect
    hurl # like curl but better
    nix-alien # run external programs in nix
  ];

  environment.variables = {
    EDITOR = "hx";
  };
}
