{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.nautilus;
in {
  options.mordrag.programs.nautilus = {
    enable = lib.mkEnableOption "Nautilus";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.nautilus];

    # quick previewer for nautilus
    services.gnome.sushi.enable = true;

    # audio and video informations: https://github.com/NixOS/nixpkgs/issues/53631#issuecomment-3704189416
    environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-libav
    ];
  };
}
