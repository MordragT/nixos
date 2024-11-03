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
      rev = "d90002a5315db3a43c39dc52c2a91a99c9330e1f";
      sha256 = "sha256-rU4WTj+2E/+OblAeK0+nzJhisz2V2/KwHBiJVBRj+LQ=";
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
