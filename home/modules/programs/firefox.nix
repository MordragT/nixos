{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.firefox;
in {
  options.mordrag.programs.firefox = {
    enable = lib.mkEnableOption "Firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      profiles.options = {
        settings = {
          "browser.startup.homepage" = "https://search.brave.com";
          "browser.search.region" = "DE";
          "browser.search.isUS" = false;
          "browser.useragent.locale" = "de-DE";
          "browser.startup.page" = 3;
          "browser.download.useDownloadDir" = false;
          "signon.rememberSignons" = false;
          "services.sync.engine.passwords" = false;
          "services.sync.engine.addons" = false;
          "services.sync.engine.history" = false;
          "services.sync.engine.bookmarks" = true;

          # Acceleration
          # "dom.webgpu.enabled" = true;
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;

          # For firefox GNOME theme
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.drawInTitlebar" = true;
          "svg.context-properties.content.enabled" = true;
        };
        userChrome = let
          firefox-gnome-theme = pkgs.fetchFromGitHub {
            owner = "rafaelmardojai";
            repo = "firefox-gnome-theme";
            rev = "33015314c12190230295cff61ced148e0f7ffe1c";
            sha256 = "sha256-e1xuHAHgeC8EU7cAIa3XfvzgI4Y7rzyTkAt9sBsgrfc=";
            # rev = "v122";
            # sha256 = "sha256-QZk/qZQVt1X53peCqB2qmWhpA3xtAVgY95pebSKaTFU=";
          };
        in ''
          @import "${firefox-gnome-theme}/userChrome.css";
          #TabsToolbar {
              visibility: collapse !important;
          }
        '';
        extensions = with pkgs.firefoxAddons; [
          bib-kit
          bibitnow
          bitwarden
          brave-search
          ghostery
          honey
          private-internet-access-ext
          rust-search-extension
          sidebery
          sponsorblock
          # ublock-origin
          youtube-shorts-block
          # pkgs.nur.repos.bandithedoge.firefoxAddons.augmented-steam
        ];
      };
    };
  };
}
