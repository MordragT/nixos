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
      # cartridges # game launcher
      # calls # phone dialer and call handler
      # not packaged chessclock
      # citations # bibtex
      # clairvoyant
      collision # check file hashes
      # commit
      # contrast # gtk check contrast
      # curtail # image compressor
      # czkawka # duplicate finder
      decibels
      delineate # View and edit dot graph
      # denaro # personal finance manager
      # deja-dup # backup tool
      # dialect # translate
      door-knocker
      # eartag # tag audio files
      easyeffects # audio effects
      # elastic # design spring animations
      # emblem
      # endeavour # task manager
      # ensembles # live DAW
      # errands # task manager
      # exhibit # 3D model viewer
      eyedropper # pick format colors
      # raider # file shredder
      resources # monitor hardware resources
      fclones-gui # find duplicate files
      # foliate # book reader
      # forge-sparks
      fractal-next # gtk matrix messaging
      # fragments # torrent downloader
      # fretboard # guitar chords
      # broken gaphor # create diagrams and uml
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
      # health # health tracker
      helvum # patchbay for pipewire
      hieroglyphic # finding LaTeX symbols from drawings
      # icon-library
      # identity # image comparison
      impression # create bootable drives
      # junction # open with preview
      # keypunch # practice typing
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
      # broken mission-center # monitor resources
      # mousai # identitfy any song
      # mousam # weather app
      # newsflash # modern feed reader
      # overskride # bluetooth client
      paleta # extract dominant color from images
      pdfarranger
      # polari # irc client
      # popsicle # flash usb with iso
      # not packaged paperclip # edit pdf metadata
      # pitivi # video editor
      # pika-backup # simple backups
      # planify # more advanced task manager
      # plots # graph plotting
      # rnote # draw notes
      # share-preview # test social media cards
      # shortwave # internet radio
      showtime # video player
      simple-scan
      switcheroo # image conversion
      # tangram # browser for pinned tabs
      # telegraph # decode morse code
      # textpieces
      turtle # gui for version control in nautilus
      upscaler # frontend for upscayl-ncnn
      # video-trimmer
      warp # send and recieve files
      # webfontkitgenerator
      # wike # search and read wikipedia
      # zrythm # music daw
    ];
  };
}
