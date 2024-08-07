{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mordrag.programs.totem;
in {
  options.mordrag.programs.totem.enable =
    mkEnableOption "Totem";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.totem # default gnome video player
    ];

    xdg.mimeApps.defaultApplications = let
      applyToAll = list:
        builtins.listToAttrs (map (key: {
            name = key;
            value = "org.gnome.Totem.desktop";
          })
          list);
    in
      applyToAll [
        "video/x-ogm+ogg"
        "video/3gp"
        "video/3gpp"
        "video/3gpp2"
        "video/dv"
        "video/divx"
        "video/fli"
        "video/flv"
        "video/mp2t"
        "video/mp4"
        "video/mp4v-es"
        "video/mpeg"
        "video/mpeg-system"
        "video/msvideo"
        "video/ogg"
        "video/quicktime"
        "video/vivo"
        "video/vnd.divx"
        "video/vnd.mpegurl"
        "video/vnd.rn-realvideo"
        "video/vnd.vivo"
        "video/webm"
        "video/x-anim"
        "video/x-avi"
        "video/x-flc"
        "video/x-fli"
        "video/x-flic"
        "video/x-flv"
        "video/x-m4v"
        "video/x-matroska"
        "video/x-mjpeg"
        "video/x-mpeg"
        "video/x-mpeg2"
        "video/x-ms-asf"
        "video/x-ms-asf-plugin"
        "video/x-ms-asx"
        "video/x-msvideo"
        "video/x-ms-wm"
        "video/x-ms-wmv"
        "video/x-ms-wmx"
        "video/x-ms-wvx"
        "video/x-nsv"
        "video/x-theora"
        "video/x-theora+ogg"
        "video/x-totem-stream"
      ];
  };
}
