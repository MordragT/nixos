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
        arch = true;
        cpu_mhz = true;
        cpu_temp = true;
        cpu_power = true;
        engine_version = true;
        frame_count = true;
        frametime = true;
        gpu_temp = true;
        gpu_mem_temp = true;
        gpu_power = true;
        gpu_core_clock = true;
        gpu_mem_clock = true;
        io_read = true;
        io_write = true;
        procmem = true;
        ram = true;
        vram = true;
        wine = true;
        winesync = true;
        present_mode = true;
        output_folder = "~/Desktop/MangoHud";
        fps_limit = [0 60 80 100 120];
        toggle_fps_limit = "Super_L+F1";
        toggle_hud = "Super_L+F3";
        toggle_logging = "Super_L+F4";
      };
    };

    xdg.configFile."MangoHud/presets.conf".text = "";
  };
}
