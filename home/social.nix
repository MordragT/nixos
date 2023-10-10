{pkgs, ...}: {
  home.packages = with pkgs; [
    # fractal-next # gtk matrix messaging
    gnome.polari # irc client not working atm
    # hexchat # irc client
    discord
    teamspeak_client
    teams-for-linux # microsoft teams
    zoom-us
    webex
    whatsapp-for-linux
  ];
}
