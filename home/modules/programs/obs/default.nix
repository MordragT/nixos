{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.obs;
in {
  options.mordrag.programs.obs = {
    enable = lib.mkEnableOption "OBS";
  };

  config = let
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "obs";
      rev = "985431cfc252c41fc151c50f91d265e16da03e83";
      sha256 = "KCRteMD8DyanPPMZZoVTXHy6xt+1HjozGTnbER1AH0M=";
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
