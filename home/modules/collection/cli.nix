{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.collection.cli;
in {
  options.mordrag.collection.cli = {
    enable = lib.mkEnableOption "CLI";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      distrobox
      hollywood # fake hacking
      step-cli # generate certificates
      ventoy # create bootable usb drive for isos
      xorg.xlsclients
      yt-dlp # download youtube videos

      # byfl # compiler based application analysis
      # likwid # performance monitoring
      # renderdoc # debug graphics
      # vkmark
      # vulkan-raytracing
      # p7zip
      # ollama # run large language models locally
      # nodePackages.reveal-md # create presentations from markdown
      # poppler_utils # utils for pdfs
      # difftastic # a diff tool
      # hexyl # hex viewer
      # fzf # fuzzy file finder TODO if used copy to system

      # Version Control
      # pijul # alternative vcs
      # awscli2 # amazon web services
      # (dvc.override {enableAWS = true;}) # data version control
      # dud # dvc alternative with rclone backend written in go
      # rclone # sync data with cloud

      # Media
      # asciinema # record terminals
      # ffmpeg_6-full
      # silicon # rust tool to create beautiful code images

      # Security
      # authoscope # scriptable network authentication cracker
      # macchanger # change the network's mac address
      # rustscan # modern portscanner
      # steghide # stenography hiding in files
      # step-cli # generate certificates
      # sn0int # semi automatic osint framework

      # Utils
      # freshfetch # neofetch alternative
      # grex # create regular expressions
      # hyperfine # benchmarking
      # gping # ping with a graph
      # sd # sed and awk replacement using regex
      # pueue # send commands into queue to execute
      # nomino # batch renaming
      # ouch # (de)compressor with sane interface
      # ripgrep # grep alternative
      # procs # modern ps replacement
      # hurl # like curl but better
      # brightnessctl
      # cpufetch # fetch cpu information
      # mesa-demos
      # expect # automate interactive applications
    ];
  };
}
