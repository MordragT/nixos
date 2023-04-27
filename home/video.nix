{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yt-dlp # download youtube videos
    kooha # screen recording
    waifu2x-converter-cpp
    pitivi # video editor
    mpv # customizable video player
    celluloid # gtk mpv frontend
    asciinema # record terminals
    # astrofox # create audio videos
    #superview # change asepct ratio of videos
    #dandere2x # upscale anime videos
    ffmpeg
  ];
}


