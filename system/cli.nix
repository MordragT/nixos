{ pkgs, ... }:
{
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

    cpufetch # fetch cpu information
    ventoy-bin # create bootable usb drive for isos
    trash-cli # put files in trash
    expect # automate interactive applications
  ];

  programs.bandwhich.enable = true; # view network utilization
}
