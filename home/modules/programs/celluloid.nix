{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mordrag.programs.celluloid;
in {
  options.mordrag.programs.celluloid.enable =
    mkEnableOption "Celluloid";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.celluloid # gtk mpv frontend
    ];

    xdg.mimeApps.defaultApplications = let
      applyToAll = list:
        builtins.listToAttrs (map (key: {
            name = key;
            value = "io.github.celluloid_player.Celluloid.desktop";
          })
          list);
    in
      applyToAll [
        "audio/3gpp"
        "audio/3gpp2"
        "audio/aac"
        "audio/ac3"
        "audio/amr"
        "audio/amr-wb"
        "audio/basic"
        "audio/dv"
        "audio/eac3"
        "audio/flac"
        "audio/m4a"
        "audio/midi"
        "audio/mp1"
        "audio/mp2"
        "audio/mp3"
        "audio/mp4"
        "audio/mpeg"
        "audio/mpegurl"
        "audio/mpg"
        "audio/ogg"
        "audio/opus"
        "audio/scpls"
        "audio/vnd.dolby.heaac.1"
        "audio/vnd.dolby.heaac.2"
        "audio/vnd.dolby.mlp"
        "audio/vnd.dts"
        "audio/vnd.dts.hd"
        "audio/vnd.rn-realaudio"
        "audio/wav"
        "audio/webm"
        "audio/x-aac"
        "audio/x-aiff"
        "audio/x-ape"
        "audio/x-flac"
        "audio/x-gsm"
        "audio/x-it"
        "audio/x-m4a"
        "audio/x-matroska"
        "audio/x-mod"
        "audio/x-mp1"
        "audio/x-mp2"
        "audio/x-mp3"
        "audio/x-mpeg"
        "audio/x-mpegurl"
        "audio/x-mpg"
        "audio/x-ms-asf"
        "audio/x-ms-wma"
        "audio/x-musepack"
        "audio/x-pn-aiff"
        "audio/x-pn-au"
        "audio/x-pn-realaudio"
        "audio/x-pn-wav"
        "audio/x-real-audio"
        "audio/x-realaudio"
        "audio/x-s3m"
        "audio/x-scpls"
        "audio/x-shorten"
        "audio/x-speex"
        "audio/x-tta"
        "audio/x-vorbis"
        "audio/x-vorbis+ogg"
        "audio/x-wav"
        "audio/x-wavpack"
        "audio/x-xm"
        "video/3gp"
        "video/3gpp"
        "video/3gpp2"
        "video/divx"
        "video/dv"
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
        "video/vnd.mpegurl"
        "video/vnd.rn-realvideo"
        "video/webm"
        "video/x-avi"
        "video/x-flc"
        "video/x-fli"
        "video/x-flv"
        "video/x-m4v"
        "video/x-matroska"
        "video/x-mpeg"
        "video/x-mpeg-system"
        "video/x-mpeg2"
        "video/x-ms-asf"
        "video/x-ms-wm"
        "video/x-ms-wmv"
        "video/x-ms-wmx"
        "video/x-msvideo"
        "video/x-nsv"
        "video/x-ogm+ogg"
        "video/x-theora"
        "video/x-theora+ogg"
      ];
  };
}
