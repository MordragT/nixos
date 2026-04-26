{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.mangohud;
in
{
  options.mordrag.programs.mangohud = {
    enable = lib.mkEnableOption "MangoHud";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.mangohud ];

      etc."mangohud/MangoHud.conf".text = ''
        arch
        cpu_mhz
        cpu_temp
        cpu_power
        engine_version
        font_size=16
        frame_count
        frametime
        gpu_temp
        gpu_mem_temp
        gpu_power
        gpu_core_clock
        gpu_mem_clock
        # hud_compact
        io_read
        io_write
        procmem
        ram
        vram
        wine
        winesync
        present_mode
        position=top-right
        output_folder=$XDG_RUNTIME_DIR/mangohud
        fps_limit=0,60,80,100,120
        toggle_fps_limit=Super_L+F1
        toggle_hud=Super_L+F3
        toggle_logging=Super_L+F4
      '';
    };
  };
}
