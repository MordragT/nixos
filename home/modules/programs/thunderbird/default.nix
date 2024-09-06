{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.thunderbird;

  gnome-theme = pkgs.fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "thunderbird-gnome-theme";
    rev = "65d5c03fc9172d549a3ea72fd366d544981a002b";
    sha256 = "sha256-nQBz2PW3YF3+RTflPzDoAcs6vH1PTozESIYUGAwvSdA=";
  };
in {
  options.mordrag.programs.thunderbird = {
    enable = lib.mkEnableOption "Thunderbird";
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird;
      profiles.options = {
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
          "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
        };
        # userChrome = ''
        #   @import "${gnome-theme}/userChrome.css";
        # '';
        # userContent = ''
        #   @import "${gnome-theme}/userContent.css";
        # '';
      };
    };
  };
}
