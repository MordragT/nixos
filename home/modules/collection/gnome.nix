{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.collection.gnome;
in {
  options.mordrag.collection.gnome = {
    enable = lib.mkEnableOption "Gnome";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      amberol # simple audio player
      # apostrophe # markdown editor
      # audio-sharing
      # authenticator # generate two-factor codes
      baobab # disk usage analyzer
      # blanket # listen to chill sounds
      # boatswain # control elgato stream deck
      bustle # inspect dbus messages
      # cartridges # game launcher
      # calls # phone dialer and call handler
      chess-clock
      # citations # bibtex
      # clairvoyant
      collision # check file hashes
      # commit
      # contrast # gtk check contrast
      crosswords
      # curtail # image compressor
      # czkawka # duplicate finder
      decibels # play audio
      delineate # View and edit dot graph
      # denaro # personal finance manager
      # deja-dup # backup tool
      # dialect # translate
      diebahn # train info
      distroshelf # distrobox manager
      door-knocker # xdg-desktop-portal info
      drum-machine # create drum patterns
      # eartag # tag audio files
      easyeffects # audio effects
      # elastic # design spring animations
      emblem # generate project icons
      # endeavour # task manager
      # ensembles # live DAW
      # errands # task manager
      exhibit # 3D model viewer
      eyedropper # pick format colors
      # raider # file shredder
      resources # monitor hardware resources
      fclones-gui # find duplicate files
      # foliate # book reader
      # forge-sparks
      fractal # gtk matrix messaging
      # fragments # torrent downloader
      # fretboard # guitar chords
      # gaphor # create diagrams and uml
      ghex # hex editor
      # glide-media-player
      gnome-boxes
      gnome-calculator
      gnome-calendar
      # gnome-color-manager
      # gnome-decoder # scan qr codes
      # gnome-font-viewer
      # gnome-frog # extract text from images
      # gnome-obfuscate # censor private information
      # gnome-podcasts # listen to podcast
      # gnome-secrets # password manager
      # gnome-sound-recorder
      # gnome-solanum # pomodoro timer
      gnome-system-monitor
      # gnome-tweaks
      halftone # create pixel art images
      # health # health tracker
      helvum # patchbay for pipewire
      hieroglyphic # finding LaTeX symbols from drawings
      # icon-library
      # identity # image comparison
      impression # create bootable drives
      # junction # open with preview
      keypunch # practice typing
      # khronos # track task time
      # kooha # screen recording
      # komikku # read manga
      # lact # linux gpu configuration tool
      # letterpress # create ascii art
      loupe # image viewer
      # lorem # generate placeholder text
      # lutris
      # markets # gtk crypto market prices
      # metadata-cleaner
      mission-center # monitor resources
      mousai # identitfy any song
      # mousam # weather app
      # newsflash # modern feed reader
      # overskride # bluetooth client
      paleta # extract dominant color from images
      pdfarranger
      pinta # draw/editing
      # polari # irc client
      # popsicle # flash usb with iso
      paper-clip # edit pdf metadata
      # piper # mouse manager
      # pitivi # video editor
      # pika-backup # simple backups
      # planify # more advanced task manager
      # plots # graph plotting
      rnote # draw notes
      share-preview # test social media cards
      # shortwave # internet radio
      showtime # video player
      simple-scan
      switcheroo # image conversion
      # tangram # browser for pinned tabs
      # telegraph # decode morse code
      # textpieces
      turtle # gui for version control in nautilus
      typewriter # create typst docs
      upscaler # frontend for upscayl-ncnn
      # video-trimmer
      warp # send and recieve files
      # webfontkitgenerator
      # wike # search and read wikipedia
      # zrythm # music daw
    ];
  };
}
