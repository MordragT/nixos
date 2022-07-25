{ pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;

  home.username = "tom";
  home.homeDirectory = pkgs.lib.mkForce "/home/tom";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Packages
  home.packages = with pkgs; [
    # Rust cli
    hua # My own package manager
    gitoxide # alternative git still wip
    pijul # alternative vcs
    git-cliff # generate changelogs
    mcfly # Upgraded shell history (ctrl+r)
    dua # disk usage analysis
    xsel # clipboard for helix
    helix # Kakoune style editor
    lapce # code editor
    bottom # htop alike   
    macchina # neofetch alike
    just # make alike
    navi # interactive cheat sheet
    tealdeer # tldr
    du-dust # file system usage
    watchexec # executes command on modifications
    tokei # count lines of code
    onefetch # git summary 
    freshfetch # neofetch alternative
    grex # create regular expressions
    hexyl # hex viewer
    zellij # terminal workspace
    hyperfine # benchmarking
    gping # ping with a graph
    sd # sed and awk replacement using regex   
    fd # find replacement
    zola # static site generator # lieber in flake ?
    rustscan # modern portscanner
    sn0int # semi automatic osint framework
    authoscope # scriptable network authentication cracker
    rbw # biwtarden cli manager
    comoji
    himalaya # cli email client
    mdbook # create books from markdown
    mdbook-katex # render math notations in mdbook
    mdbook-mermaid # render mermaid.js
    miniserve # serve some files via http
    hexdino # hex editor
    difftastic # a diff tool
    nix-index # locate files of nix packages
    ffsend # securely share files
    pueue # send commands into queue to execute
    nomino # batch renaming
    ouch # (de)compressor with sane interface
    skim # fuzzy finder
    rnote # draw notes
    grass # sass compiler
    lottieconv # convert lottie into gif or webp
    nixpkgs-fmt

    # Rust GTK
    kooha # screen recording
    contrast # gtk check contrast
    fractal # gtk matrix messaging
    markets # gtk crypto market prices
    gnome-obfuscate # censor private information
    pika-backup # simple backups
    icon-library

    # GTK Apps
    amberol
    apostrophe # markdown editor
    blanket # listen to chill sounds
    gaphor # create diagrams and uml
    metadata-cleaner
    khronos # track task time
    tootle # mastodon client
    gnome.gnome-color-manager
    # gnome.polari # irc client not working atm
    hexchat
    gnome.gnome-boxes
    gnome.gnome-todo
    gnome.gnome-sound-recorder
    gnome.ghex
    # gnome-latex
    pdfarranger
    junction

    # Downloads        
    megacmd # File sharing
    qbittorrent
    fragments

    # IT Security & Reverse Engineering
    cutter
    macchanger # change the network's mac address
    tor-browser-bundle-bin
    scrcpy # control android from pc

    # Development
    dbeaver # sql client
    godot # game engine
    conda # python package manager
    texlab # latex lsp implementation

    # Asset creation
    blender
    blockbench-electron
    krita
    inkscape
    zrythm
    akira-unstable

    # Video
    pitivi
    mpv
    yt-dlp # download youtube videos
    asciinema # record terminals
    astrofox

    # Music
    spotify

    # Social    
    discord
    teams
    zoom-us
    webex

    # Gaming
    steam-tui
    steamcmd
    steam-run
    sc-controller
    # steamcontroller
    lutris
    # bottles
    teamspeak_client
    protonup
    vulkan-tools
    # pufferpanel # game server
    minecraft
    optifine
    # pkgs.nur.repos.dukzcry.gamescope
    mangohud

    # Documents
    libreoffice-fresh
    onlyoffice-bin
    nodePackages.reveal-md
    okular
    # zotero

    # Tools
    cpufetch
    ventoy-bin # create bootable usb drive for isos
    cabextract
    unzip
    wget
    trash-cli # put files in trash
    openssl # required by lol installer
    gnutls # required by ubisoft connect
    expect
    usbmuxd
    appimage-run
    spflashtool # flash android mtk
  ];

  xdg = {
    enable = true;
    userDirs.enable = true;
    configFile =
      let
        toml = pkgs.formats.toml { };
      in
      {
        "helix/config.toml".source =
          toml.generate "helix-conf" {
            theme = "gruvbox";

            # editor.cursor-shape.normal = "bar";
          };
        "findex/style.css".source =
          builtins.toFile "style.css" ''
            	.findex-query {
            	    color: white;
            	    padding: 15px;
            	    font-size: 20px;
            	    border: none;
            	}
        
            	.findex-result-row:selected .findex-result-app-name {
            	    color: black;
            	}
        
            	.findex-result-icon {
            	    margin: 10px;
            	}
        
            	.findex-result-app-name {
            	    color: #fff;
            	    margin: 10px;
            	    font-weight: bold;
            	    font-size: 15px;
            	}
          '';
      };
  };

  pam.sessionVariables = {
    XDG_CONFIG_HOME = "/home/tom/.config";
    XDG_CACHE_HOME = "/home/tom/.cache";
    XDG_DATA_HOME = "/home/tom/.local/share";
    XDG_STATE_HOME = "/home/tom/.local/state";
    XDG_DATA_DIRS = "/usr/share:/usr/local/share:/home/tom/.local/share/:/home/tom/.nix-profile/share";
  };

  programs.bat = {
    enable = true;
    config.theme = "gruvbox-dark";
  };

  programs.broot = {
    enable = true;
    skin = {
      default = "rgb(235, 219, 178) none / rgb(189, 174, 147) none";
      tree = "rgb(168, 153, 132) None / rgb(102, 92, 84) None";
      parent = "rgb(235, 219, 178) none / rgb(189, 174, 147) none Italic";
      file = "None None / None  None Italic";
      directory = "rgb(131, 165, 152) None Bold / rgb(131, 165, 152) None";
      exe = "rgb(184, 187, 38) None";
      link = "rgb(104, 157, 106) None";
      pruning = "rgb(124, 111, 100) None Italic";
      perm__ = "None None";
      perm_r = "rgb(215, 153, 33) None";
      perm_w = "rgb(204, 36, 29) None";
      perm_x = "rgb(152, 151, 26) None";
      owner = "rgb(215, 153, 33) None Bold";
      group = "rgb(215, 153, 33) None";
      count = "rgb(69, 133, 136) rgb(50, 48, 47)";
      dates = "rgb(168, 153, 132) None";
      sparse = "rgb(250, 189,47) None";
      content_extract = "ansi(29) None Italic";
      content_match = "ansi(34) None Bold";
      git_branch = "rgb(251, 241, 199) None";
      git_insertions = "rgb(152, 151, 26) None";
      git_deletions = "rgb(190, 15, 23) None";
      git_status_current = "rgb(60, 56, 54) None";
      git_status_modified = "rgb(152, 151, 26) None";
      git_status_new = "rgb(104, 187, 38) None Bold";
      git_status_ignored = "rgb(213, 196, 161) None";
      git_status_conflicted = "rgb(204, 36, 29) None";
      git_status_other = "rgb(204, 36, 29) None";
      selected_line = "None rgb(60, 56, 54) / None rgb(50, 48, 47)";
      char_match = "rgb(250, 189, 47) None";
      file_error = "rgb(251, 73, 52) None";
      flag_label = "rgb(189, 174, 147) None";
      flag_value = "rgb(211, 134, 155) None Bold";
      input = "rgb(251, 241, 199) None / rgb(189, 174, 147) None Italic";
      status_error = "rgb(213, 196, 161) rgb(204, 36, 29)";
      status_job = "rgb(250, 189, 47) rgb(60, 56, 54)";
      status_normal = "None rgb(40, 38, 37) / None None";
      status_italic = "rgb(211, 134, 155) rgb(40, 38, 37) Italic / None None";
      status_bold = "rgb(211, 134, 155) rgb(40, 38, 37) Bold / None None";
      status_code = "rgb(251, 241, 199) rgb(40, 38, 37) / None None";
      status_ellipsis = "rgb(251, 241, 199) rgb(40, 38, 37)  Bold / None None";
      purpose_normal = "None None";
      purpose_italic = "rgb(177, 98, 134) None Italic";
      purpose_bold = "rgb(177, 98, 134) None Bold";
      purpose_ellipsis = "None None";
      scrollbar_track = "rgb(80, 73, 69) None / rgb(50, 48, 47) None";
      scrollbar_thumb = "rgb(213, 196, 161) None / rgb(102, 92, 84) None";
      help_paragraph = "None None";
      help_bold = "rgb(214, 93, 14) None Bold";
      help_italic = "rgb(211, 134, 155) None Italic";
      help_code = "rgb(142, 192, 124) rgb(50, 48, 47)";
      help_headers = "rgb(254, 128, 25) None Bold";
      help_table_border = "rgb(80, 73, 69) None";
      preview_title = "rgb(235, 219, 178) rgb(40, 40, 40) / rgb(189, 174, 147) rgb(40, 40, 40)";
      preview = "rgb(235, 219, 178) rgb(40, 40, 40) / rgb(235, 219, 178) rgb(40, 40, 40)";
      preview_line_number = "rgb(124, 111, 100) None / rgb(124, 111, 100) rgb(40, 40, 40)";
      preview_match = "None ansi(29) Bold";
      hex_null = "rgb(189, 174, 147) None";
      hex_ascii_graphic = "rgb(213, 196, 161) None";
      hex_ascii_whitespace = "rgb(152, 151, 26) None";
      hex_ascii_other = "rgb(254, 128, 25) None";
      hex_non_ascii = "rgb(214, 93, 14) None";
      staging_area_title = "rgb(235, 219, 178) rgb(40, 40, 40) / rgb(189, 174, 147) rgb(40, 40, 40)";
      mode_command_mark = "gray(5) ansi(204) Bold";
    };
  };

  programs.chromium.enable = true;

  programs.exa.enable = true;

  programs.firefox = {
    enable = true;
    extensions =
      let
        buildFirefoxXpiAddon = pkgs.lib.makeOverridable ({ pname
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
          meta = with pkgs.lib;
            {
              homepage = "https://github.com/Langenscheiss/bibitnow";
              description = "Instantly creates a Bibtex, RIS, Endnote, APA, MLA or (B)Arnold S.";
              license = licenses.mpl20;
              platforms = platforms.all;
            };
        };
        pia = buildFirefoxXpiAddon {
          pname = "PrivateInternetAccess";
          version = "3.2.0";
          addonId = "{3e4d2037-d300-4e95-859d-3cba866f46d3}";
          url = "https://addons.mozilla.org/firefox/downloads/file/3916166/private_internet_access_ext-3.2.0.xpi";
          sha256 = "RbiCnMerNjakrFIBXiPnzIxvohh3zgYM1R5WU2yVhbk=";
          meta = with pkgs.lib;
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
          meta = with pkgs.lib;
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
            rev = "fc44130eb94467f6392fc86dd136235013c9ffd0";
            hash = "sha256-D6HBSFnlttKeIg64nW6gAt7h6YNeGbX6mYGV3pJXZNM=";
          };
        in
        ''
          @import "${firefox-gnome-theme}/userChrome.css";

          #TabsToolbar {
              visibility: collapse !important;
          }
        '';
    };
  };

  programs.git = {
    enable = true;
    userName = "Thomas Wehmöller";
    userEmail = "connect.mordrag@gmx.de";
  };

  programs.nushell = {
    enable = true;
    configFile.text = ''      
      def , [...pkgs: string] {
        let $pkgs = ($pkgs
          | each { |pkg| "nixpkgs#" + $pkg }
          | str collect ' ')
        let cmd = $"nix shell ($pkgs)"
        bash -c $cmd
      }
      
      alias comojit = comoji commit
      
      let-env config = {
        table_mode: rounded
      }
    '';
    envFile.text = "";
  };

  programs.obs-studio.enable = true;

  programs.vscode = {
    enable = true;
    userSettings = {
      "window.zoomLevel" = 0;
      "editor.minimap.enabled" = false;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'Jetbrains Mono', 'monospace', monospace, 'Droid Sans Fallback'";
      "editor.fontSize" = 14;
      "terminal.integrated.fontSize" = 14;
      "editor.renderWhitespace" = "none";
      "editor.folding" = false;
      "editor.glyphMargin" = true;
      "explorer.openEditors.visible" = 0;
      "workbench.activityBar.visible" = true;
      "workbench.editor.showTabs" = false;
      "workbench.statusBar.visible" = true;
      "workbench.sideBar.location" = "right";
      "workbench.editor.showIcons" = false;
      "workbench.colorTheme" = "One Dark Vibrant";
      "editor.occurrencesHighlight" = false;
      "workbench.startupEditor" = "newUntitledFile";
      "workbench.tree.renderIndentGuides" = "none";
      "editor.acceptSuggestionOnEnter" = "off";
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "editor.renderIndentGuides" = false;
      "editor.formatOnSave" = true;
      "terminal.integrated.rendererType" = "dom";
      "git.enableSmartCommit" = true;
      "git.autofetch" = true;
      "editor.tabCompletion" = "on";
      "editor.dragAndDrop" = false;
      "editor.lineNumbers" = "interval";
      "editor.renderLineHighlight" = "none";
      "editor.cursorBlinking" = "expand";
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.factorypath" = true;
        "**/.idea" = true;
        "**/.project" = true;
        "**/.settings" = true;
      };
      "breadcrumbs.enabled" = false;
      "workbench.editor.labelFormat" = "short";
      "window.menuBarVisibility" = "toggle";
      "window.title" = "\${dirty}\${activeEditorShort}\${separator}\${rootName}";
      "debug.allowBreakpointsEverywhere" = true;
      "debug.showBreakpointsInOverviewRuler" = true;
      "rust-analyzer.procMacro.enable" = false;
      "lldb.verboseLogging" = true;
      "files.associations" = {
        "*.lalrpop" = "rust";
        "*.tera" = "html";
      };
      "ltex.language" = "de-DE";
      # "latex-workshop.latex.recipes" = [
      #   {
      #     "name" = "tectonic";
      #     "tools" = [ "tectonic" ];      
      #   }    
      # ];
    };
    keybindings = [
      {
        key = "ctrl+k ctrl+e";
        command = "workbench.view.explorer";
      }
      {
        key = "ctrl+k ctrl+v";
        command = "workbench.view.scm";
      }
      {
        key = "ctrl+k ctrl+d";
        command = "workbench.view.debug";
      }
      {
        key = "ctrl+k ctrl+x";
        command = "workbench.extensions.action.showInstalledExtensions";
      }
      {
        key = "ctrl+n";
        command = "explorer.newFile";
        when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
      }
      {
        key = "shift+ctrl+n";
        command = "explorer.newFolder";
        when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
      }
      {
        key = "ctrl+r";
        command = "workbench.files.action.refreshFilesExplorer";
        when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
      }
    ];
    extensions = with pkgs.vscode-extensions; [
      pkgs.fenix.rust-analyzer-vscode-extension
      # vadimcn.vscode-lldb
      ms-python.python
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare
      # bbenoist.nix
      bungcip.better-toml
      tiehuis.zig
      # ms-vscode.cpptools
      xaver.clang-format
      gruntfuggly.todo-tree
      # james-yu.latex-workshop
      skellock.just
      jnoortheen.nix-ide
      # arrterian.nix-env-selector
      valentjn.vscode-ltex
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "texlab";
        publisher = "efoerster";
        version = "4.0.0";
        sha256 = "0bR/SPi4NkHT0GRaHyuT2A1f3vjRkhVH7wXcKq3LsEE=";
      }
      {
        name = "vscode-intelephense-client";
        publisher = "bmewburn";
        version = "1.8.2";
        sha256 = "1sla3pl3jfdawjmscwf2ml42xhwjaa9ywdgdpl6v99p10w6rvx9s";
      }
      {
        name = "flowistry";
        publisher = "wcrichton";
        version = "0.5.27";
        sha256 = "1rhp32az7smzhdc6gbz546v0l0507pmhw9y7zsdw43hb5sh1ykj7";
      }
      {
        name = "one-dark-vibrant";
        publisher = "Mordrag";
        version = "0.0.4";
        sha256 = "0wd3ik6aspmdbylwshbkw2cmckyyf6n98d3anai5mvwyvidfymwb";
      }
    ];
  };

  programs.zoxide.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "colorize" "z" ];
    };

    shellAliases = {
      "..." = "../..";
    };

    initExtra = ''
      export PATH=$PATH:$HOME/.bin:$HOME/.local/bin
        
      # Rust
      export PATH=$PATH:$HOME/.cargo/bin
        
      # Editor
      export EDITOR="hx"
    '';
  };

  wayland.windowManager.sway.enable = true;
}
