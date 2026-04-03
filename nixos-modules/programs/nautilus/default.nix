{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.nautilus;
in
{
  options.mordrag.programs.nautilus = {
    enable = lib.mkEnableOption "Nautilus";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.nautilus ];

    # quick previewer for nautilus
    services.gnome.sushi.enable = true;

    # TODO this is kind of broken
    # audio and video informations: https://github.com/NixOS/nixpkgs/issues/53631#issuecomment-3704189416
    # environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
    #   with pkgs.gst_all_1;
    #   lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
    #     gstreamer
    #     gst-plugins-base
    #     gst-plugins-good
    #     gst-plugins-bad
    #     gst-plugins-ugly
    #     gst-libav
    #   ];
  };
}
