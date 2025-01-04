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
          "browser.aboutConfig.showWarning" = false;
          "browser.startup.homepage" = "https://search.brave.com";
          "browser.search.region" = "DE";
          "browser.search.isUS" = false;
          "browser.useragent.locale" = "de-DE";
          "browser.startup.page" = 3;
          "browser.download.useDownloadDir" = false;

          # "font.name.monospace.x-western" = "Geist Mono";
          # "font.name.sans-serif.x-western" = "Geist";
          # "font.name.serif.x-western" = "Geist";

          "signon.rememberSignons" = false;
          # "sidebar.revamp" = true;
          # "sidebar.verticalTabs" = true;
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
            rev = "c4eec329c464f3f89ab78a56a47eee6271ea9d19";
            sha256 = "sha256-EACja6V2lNh67Xvmhr0eEM/VeqM7OlTTm/81LhRbsBE=";
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
          # csgofloat
          ghostery
          private-internet-access-ext
          rust-search-extension
          sidebery
          # skinport-plus
          sponsorblock
          # ublock-origin
          youtube-shorts-block
          # pkgs.nur.repos.bandithedoge.firefoxAddons.augmented-steam
        ];
      };
    };
  };
}
