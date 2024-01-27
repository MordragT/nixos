{pkgs, ...}: {
  home.packages = with pkgs; [
    celluloid # gtk mpv frontend
    easyeffects # audio effects
    # ensembles # live DAW
    helvum # patchbay for pipewire
    kooha # screen recording
    # broken pitivi # video editor
    # zrythm # music daw
  ];
}
