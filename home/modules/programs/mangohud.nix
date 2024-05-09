{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.programs.mangohud;
in {
  options.mordrag.programs.mangohud = {
    enable = lib.mkEnableOption "MangoHud";
  };

  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = false;
      settings = {
        full = true;
        output_folder = "~/Desktop/MangoHud";
        fps_limit = [0 60 80 100 120];
        toggle_fps_limit = "Super_L+F1";
        toggle_hud = "Super_L+F3";
        toggle_logging = "Super_L+F4";
      };
    };
  };
}
