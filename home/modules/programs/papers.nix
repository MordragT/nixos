{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.papers;
in {
  options.mordrag.programs.papers = {
    enable = lib.mkEnableOption "Papers";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.papers # succesor to evince
    ];

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "org.gnome.Papers.desktop";
    };
  };
}
