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
      audio-sharing
      # authenticator # generate two-factor codes
      baobab # disk usage analyzer
      # blanket # listen to chill sounds
      # boatswain # control elgato stream deck
      bottles
      # cartridges # game launcher
      # calls # phone dialer and call handler
      # not packaged chessclock
      citations # bibtex
      # clairvoyant
      collision # check file hashes
      # not packaged commit
      # contrast # gtk check contrast
      # curtail # image compressor
      # czkawka # duplicate finder
      # not packaged decibles
      # denaro # personal finance manager
      # dialect # translate
      # deja-dup # backup tool
      eartag # tag audio files
      # broken easyeffects # audio effects
      # elastic # design spring animations
      # emblem
      # endeavour # task manager
      # ensembles # live DAW
      # errands # task manager
      eyedropper # pick format colors
      raider # file shredder
      resources # monitor hardware resources
      fclones-gui # find duplicate files
      # foliate # book reader
      # forge-sparks
      fractal-next # gtk matrix messaging
      # broken fragments # torrent downloader
      # fretboard # guitar chords
      # broken gaphor # create diagrams and uml
      ghex # hex editor
      # glide-media-player
      gnome-calculator
      gnome-calendar
      gnome-decoder # scan qr codes
      gnome-font-viewer
      gnome-frog
      gnome-obfuscate # censor private information
      # gnome-podcasts # listen to podcast
      gnome-system-monitor
      gnome.gnome-boxes
      # gnome.gnome-color-manager
      gnome.gnome-sound-recorder
      # gnome.gnome-tweaks
      gnome.polari # irc client
      # gnome-secrets # password manager
      # health # health tracker
      helvum # patchbay for pipewire
      icon-library
      # identity # image comparison
      impression # create bootable drives
      junction # open with preview
      keypunch # practice typing
      khronos # track task time
      kooha # screen recording
      # komikku # read manga
      letterpress # create ascii art
      # lorem # generate placeholder text
      # lutris
      # markets # gtk crypto market prices
      # metadata-cleaner
      mousai # identitfy any song
      mousam # weather app
      # newsflash # modern feed reader
      # overskride # bluetooth client
      paleta # extract dominant color from images
      pdfarranger
      # popsicle # flash usb with iso
      # not packaged paperclip # edit pdf metadata
      pitivi # video editor
      # pika-backup # simple backups
      # planify # more advanced task manager
      plots # graph plotting
      rnote # draw notes
      share-preview # test social media cards
      shortwave # internet radio
      simple-scan
      gnome-solanum # pomodoro timer
      switcheroo # image conversion
      imagemagick # needed by switcheroo ??
      # tangram # browser for pinned tabs
      # telegraph # decode morse code
      textpieces
      video-trimmer
      warp # send and recieve files
      # webfontkitgenerator
      wike # search and read wikipedia
      # zrythm # music daw
    ];
  };
}
