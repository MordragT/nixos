{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.mangohud;

  mangohud_config = pkgs.writeText "MangoHud.conf" ''
    arch
    cpu_mhz
    cpu_temp
    cpu_power
    core_load
    engine_version
    font_size=24
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
    proc_vram
    wine
    winesync
    present_mode
    position=top-right
    output_folder=$XDG_RUNTIME_DIR/mangohud
    fps_limit=0,60,120,180
    toggle_fps_limit=Super_L+F1
    toggle_hud=Super_L+F3
    toggle_logging=Super_L+F4
  '';
in
{
  options.mordrag.programs.mangohud = {
    enable = lib.mkEnableOption "MangoHud";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        mangohud
        mangojuice
      ];

      sessionVariables.MANGOHUD_CONFIGFILE = "/etc/MangoHud.conf";

      # https://github.com/flightlessmango/MangoHud/blob/02be26c36241452bf5e6040d315925c9189e9aa4/src/config.cpp#L79
      etc."MangoHud.conf".source = mangohud_config;
    };

    programs.steam.package = pkgs.steam.override {
      extraEnv.MANGOHUD_CONFIGFILE = "${mangohud_config}";
    };
  };
}
