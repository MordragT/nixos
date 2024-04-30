{pkgs, ...}: {
  home.packages = with pkgs; [
    amberol # simple audio player
    apostrophe # markdown editor
    # not packaged audio-sharing
    authenticator # generate two-factor codes
    blanket # listen to chill sounds
    # boatswain # control elgato stream deck
    cartridges # game launcher
    # not packaged chessclock
    citations # bibtex
    clairvoyant
    # broken collision # check file hashes
    # not packaged commit
    curtail
    # not packaged decibles
    dialect # translate
    deja-dup # backup tool
    eartag # tag audio files
    # elastic
    emblem
    errands
    eyedropper # pick format colors
    raider # file shredder
    forge-sparks
    fragments # torrent downloader
    fretboard
    # broken gaphor # create diagrams and uml
    health # health tracker
    identity # image viewer
    impression # create bootable drives
    junction # open with preview
    khronos # track task time
    # komikku # read manga
    # not packaged letterpress # create ascii art
    lorem # generate placeholder text
    metadata-cleaner
    mousai # identitfy any song
    newsflash # modern feed reader
    gnome-obfuscate # censor private information
    # not packaged paperclip # edit pdf metadata
    pika-backup # simple backups
    plots # graph plotting
    gnome-decoder # scan qr codes
    gnome-podcasts # listen to podcasts
    gnome.polari # irc client
    # gnome-secrets # password manager
    # not packaged sharepreview # test social media cards
    shortwave # internet radio
    gnome-solanum # pomodoro timer
    switcheroo
    # tangram # browser for pinned tabs
    telegraph # decode morse code
    textpieces
    video-trimmer
    warp # send and recieve files
    webfontkitgenerator
    wike # search and read wikipedia
  ];
}
