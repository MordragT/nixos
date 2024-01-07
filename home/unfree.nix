{pkgs, ...}: {
  home.packages = with pkgs; [
    # matlab
    spotify # listen to music
    unigine-superposition

    # Social
    discord
    teamspeak_client
    # broken teams-for-linux # microsoft teams
    zoom-us
    webex
    # whatsapp-for-linux
  ];
}
