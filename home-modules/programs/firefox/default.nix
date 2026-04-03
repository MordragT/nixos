{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.firefox;
in
{
  options.mordrag.programs.firefox = {
    enable = lib.mkEnableOption "Firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.options = {
        extensions.packages = with pkgs.firefox-addons; [
          bib-kit
          bitwarden-password-manager
          brave-search
          # csgofloat
          ghostery
          rust-search-extension
          sponsorblock
          # ublock-origin
          youtube-shorts-block
        ];

        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.startup.homepage" = "https://search.brave.com";
          "browser.search.region" = "DE";
          "browser.search.isUS" = false;
          "browser.useragent.locale" = "de-DE";
          "browser.startup.page" = 3;
          "browser.download.useDownloadDir" = false;

          "signon.rememberSignons" = false;
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "services.sync.engine.passwords" = false;
          "services.sync.engine.addons" = false;
          "services.sync.engine.history" = false;
          "services.sync.engine.bookmarks" = true;

          # Acceleration
          "dom.webgpu.enabled" = true;
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
        };
      };
    };
  };
}
