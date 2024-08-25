{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.zen-browser;
in {
  options.mordrag.programs.zen-browser = {
    enable = lib.mkEnableOption "Zen Browser";
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/http" = "zen-browser.desktop";
      "x-scheme-handler/https" = "zen-browser.desktop";
      "application/xhtml+xml" = "zen-browser.desktop";
      "text/html" = "zen-browser.desktop";
    };

    home.packages = [pkgs.zen-browser-bin];

    home.file.".zen/profiles.ini".text = lib.generators.toINI {} {
      General = {
        StartWithLastProfile = 1;
        Version = 2;
      };

      Profile0 = {
        Name = "Default";
        Path = "default";
        IsRelative = 1;
        ZenAvatarPath = "chrome://browser/content/zen-avatars/avatar-32.svg";
        Default = 1;
      };
    };
    home.file.".zen/default/extensions" = {
      source = let
        env = pkgs.buildEnv {
          name = "zen-extensions";
          paths = with pkgs.firefoxAddons; [
            bib-kit
            bibitnow
            bitwarden
            brave-search
            ghostery
            honey
            private-internet-access-ext
            rust-search-extension
            sponsorblock
            youtube-shorts-block
          ];
        };
      in "${env}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
      recursive = true;
      force = true;
    };
  };
}
