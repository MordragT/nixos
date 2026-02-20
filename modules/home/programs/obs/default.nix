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

  config =
    let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "obs";
        rev = "05c55ffe499c183c98be469147f602c3f8e84b87";
        hash = "sha256-ezz3euxO5lxyVaVFDPjNowpivAm9tRGHt8SbflAdkA8=";
      };
    in
    lib.mkIf cfg.enable {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
          obs-move-transition
          input-overlay
        ];
      };

      xdg.configFile."obs-studio/themes/".source = "${catppuccin}/themes";
    };
}
