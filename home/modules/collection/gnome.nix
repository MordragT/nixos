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
      # not packaged audio-sharing
      # authenticator # generate two-factor codes
      # blanket # listen to chill sounds
      # boatswain # control elgato stream deck
      bottles
      # cartridges # game launcher
      # calls # phone dialer and call handler
      celluloid # gtk mpv frontend
      # not packaged chessclock
      # citations # bibtex
      # clairvoyant
      # broken collision # check file hashes
      # not packaged commit
      # contrast # gtk check contrast
      # curtail # image compressor
      # czkawka # duplicate finder
      # not packaged decibles
      # denaro # personal finance manager
      # dialect # translate
      # deja-dup # backup tool
      eartag # tag audio files
      easyeffects # audio effects
      # elastic # design spring animations
      # emblem
      # endeavour # task manager
      # ensembles # live DAW
      # errands # task manager
      eyedropper # pick format colors
      raider # file shredder
      fclones-gui # find duplicate files
      # foliate # book reader
      # forge-sparks
      fractal-next # gtk matrix messaging
      fragments # torrent downloader
      # fretboard # guitar chords
      # broken gaphor # create diagrams and uml
      # glide-media-player
      gnome-decoder # scan qr codes
      gnome-frog
      gnome-obfuscate # censor private information
      # gnome-podcasts # listen to podcast
      gnome.ghex # hex editor
      gnome.gnome-boxes
      gnome.gnome-calculator
      gnome.gnome-calendar
      # gnome.gnome-color-manager
      gnome.gnome-sound-recorder
      gnome.gnome-system-monitor
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
      # not packaged letterpress # create ascii art
      # lorem # generate placeholder text
      loupe # image viewer
      # lutris
      # markets # gtk crypto market prices
      # metadata-cleaner
      mousai # identitfy any song
      mousam # weather app
      # newsflash # modern feed reader
      # overskride # bluetooth client
      papers # succesor to evince
      paleta # extract dominant color from images
      pdfarranger
      # popsicle # flash usb with iso
      # not packaged paperclip # edit pdf metadata
      # broken pitivi # video editor
      # pika-backup # simple backups
      # planify # more advanced task manager
      plots # graph plotting
      rnote # draw notes
      # not packaged sharepreview # test social media cards
      shortwave # internet radio
      simple-scan
      gnome-solanum # pomodoro timer
      switcheroo
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
