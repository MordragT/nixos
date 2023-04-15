{ pkgs, ... }:
let
  lib = pkgs.lib;
in
{
  programs.firefox = {
    enable = true;
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

        # For firefox GNOME theme
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.drawInTitlebar" = true;
        "svg.context-properties.content.enabled" = true;
      };
      userChrome =
        let
          firefox-gnome-theme = pkgs.fetchFromGitHub {
            owner = "rafaelmardojai";
            repo = "firefox-gnome-theme";
            rev = "9b88fd9bb16da01c8535889e04e14231e853de6c";
            sha256 = "AeRlezeG5jBcRN6IwVxXdK+zv9OlPdoNJkpJ1Lha5Ho=";
          };
        in
        ''
          @import "${firefox-gnome-theme}/userChrome.css";
          #TabsToolbar {
              visibility: collapse !important;
          }
        '';

      extensions =
        let
          buildFirefoxXpiAddon = lib.makeOverridable ({ pname
                                                      , version
                                                      , addonId
                                                      , url
                                                      , sha256
                                                      , meta
                                                      , ...
                                                      }: pkgs.stdenv.mkDerivation {
            name = "${pname}-${version}";

            inherit meta;

            src = pkgs.fetchurl { inherit url sha256; };

            preferLocalBuild = true;
            allowSubstitutes = true;

            buildCommand = ''
              dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
              mkdir -p "$dst"
              install -v -m644 "$src" "$dst/${addonId}.xpi"
            '';
          });
          bibitnow = buildFirefoxXpiAddon {
            pname = "BibItNow!";
            version = "0.908";
            addonId = "bibitnow018@aqpl.mc2.chalmers.se";
            url = "https://addons.mozilla.org/firefox/downloads/file/3937047/bibitnow-0.908.xpi";
            sha256 = "QIWgTLD+WVZ3+lt/pjDYF+CRiMz7/NNYbMwWLv6mdGc=";
            meta = with lib;
              {
                homepage = "https://github.com/Langenscheiss/bibitnow";
                description = "Instantly creates a Bibtex, RIS, Endnote, APA, MLA or (B)Arnold S.";
                license = licenses.mpl20;
                platforms = platforms.all;
              };
          };
          pia = buildFirefoxXpiAddon {
            pname = "PrivateInternetAccess";
            version = "2.1.4.2";
            addonId = "{3e4d2037-d300-4e95-859d-3cba866f46d3}";
            url = "https://addons.mozilla.org/firefox/downloads/file/3502793/private_internet_access_ext-2.1.4.2.xpi";
            sha256 = "FQ0xLL6KgmLwRUCiwG4iU5IOVmRMFUfqK6BZtimY8ok=";
            meta = with lib;
              {
                homepage = "https://www.privateinternetaccess.com/";
                description = "Defeat censorship, unblock any website and access the open Internet the way it was meant to be with Private Internet Access";
                license = licenses.mit;
                platforms = platforms.all;
              };
          };
          brave-search = buildFirefoxXpiAddon {
            pname = "BraveSearch";
            version = "1.0.1";
            addonId = "BraveSearchExtension@io.Uvera";
            url = "https://addons.mozilla.org/firefox/downloads/file/3809887/brave_search-1.0.1.xpi";
            sha256 = "lIgiSnoSMwI/7DNTOnjhgDSCvFANkq/LOWK3hXXfza4=";
            meta = with lib;
              {
                homepage = "https://github.com/uvera/firefox-extension-brave-search";
                description = "Adds Brave search as a search engine";
                license = licenses.mit;
                platforms = platforms.all;
              };
          };
        in
        with pkgs.nur.repos.rycee.firefox-addons; [
          sidebery
          sponsorblock
          bitwarden
          honey
          ublock-origin
          rust-search-extension
          brave-search
          bibitnow
          pia
        ];
    };
  };
}
