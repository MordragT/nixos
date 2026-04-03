{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.obs;
in
{
  options.mordrag.programs.obs = {
    enable = lib.mkEnableOption "OBS";
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-move-transition
        input-overlay
      ];
    };
  };
}
