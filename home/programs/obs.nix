{ fetchFromGitHub, ... }:
let
  catppuccin = fetchFromGitHub {
    owner = "catppuccin";
    repo = "obs";
    rev = "985431cfc252c41fc151c50f91d265e16da03e83";
    sha256 = "KCRteMD8DyanPPMZZoVTXHy6xt+1HjozGTnbER1AH0M=";
  };
in
{
  programs.obs-studio.enable = true;

  xdg.configFile."obs-studio/themes/".source = "${catppuccin}/themes";
}
