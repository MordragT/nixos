{ pkgs }:
with pkgs; [
  # CLI
  alsa-utils # configure audio devices

  # GUI
  blanket # listen to chill sounds
  amberol # simple audio player
  easyeffects # audio effects
  zrythm # music daw
  tenacity # master audio
  spotify # listen to music
]
