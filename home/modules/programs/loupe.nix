{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mordrag.programs.loupe;
in {
  options.mordrag.programs.loupe.enable =
    mkEnableOption "Loupe";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.loupe # image viewer
    ];

    xdg.mimeApps.defaultApplications = let
      applyToAll = list:
        builtins.listToAttrs (map (key: {
            name = key;
            value = "org.gnome.Loupe.desktop";
          })
          list);
    in
      applyToAll [
        "image/png"
        "image/gif"
        "image/webp"
        "image/tiff"
        "image/x-tga"
        "image/vnd-ms.dds"
        "image/x-dds"
        "image/bmp"
        "image/vnd.microsoft.icon"
        "image/vnd.radiance"
        "image/x-exr"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/x-portable-pixmap"
        "image/x-portable-anymap"
        "image/x-qoi"
        "image/svg+xml"
        "image/svg+xml-compressed"
        "image/avif"
        "image/heic"
        "image/jxl"
      ];
  };
}
