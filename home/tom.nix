{ pkgs, ... }:
let
  toml = pkgs.formats.toml {};
in {
            
  # Let Home Manager install and manage itself.
  #programs.home-manager.enable = true;
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
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
  home.stateVersion = "21.11";
    
  # Packages
  
  # nixpkgs.config = {
  #   allowUnfree = true;
  #   packageOverrides = pkgs: {
  #     # = import arball {
  #     #   config = config.nixpkgs.config;
  #     # };
  #     inherit nur;
  #   };
  # };  
    
  home.packages = with pkgs; [
    # No GTK Core Apps
    
    # Rust Apps
    # helix
    helix # Kakoune style editor
    bottom # htop alike   
    macchina # neofetch alike
    contrast # gtk check contrast
    fractal # gtk matrix messaging
    markets # gtk crypto market prices
    just # make alike # lieber in flake ?
    navi # interactive cheat sheet
    tealdeer # tldr
    du-dust # file system usage
    watchexec # executes command on modifications
    tokei # count lines of code
    onefetch # git summary 
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
    gitmoji
    himalaya # cli email client
             
    # Downloads        
    megasync # File sharing
    qbittorrent
    
    # IT Security & Reverse Engineering
    # wireshark
    cutter    
    
    # Development
    javacc # nicht lieber in flake wo gebraucht ?
    dbeaver
    
    # Asset creation
    blender
    krita
    
    # Video
    pitivi
    
    # Social    
    discord
    teams
    zoom-us
           
    cpufetch
    spotify
    droidcam # use smartphone as camera
    
    # needed for cargo install command
    rustup
    clang
    cargo2nix.package
    crate2nix
  ];
  
  xdg = {
    enable = true;
    configFile = {
      "helix/config.toml".source =
        toml.generate "helix-conf" { theme = "gruvbox"; };     
    };
  };
  
  # home.sessionVariables = {
  #   EDITOR="hx";
  # };
  
  pam.sessionVariables = {
    XDG_CONFIG_HOME =  "/home/tom/.config";
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
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      honey
      duckduckgo-privacy-essentials
      ublock-origin
      rust-search-extension
    ];
    profiles.options.settings = {
      "browser.startup.homepage" = "https://duckduckgo.com";
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
    };
  }; 
    
  programs.git = {
    enable = true;
    userName = "Thomas Wehmöller";
    userEmail = "connect.mordrag@gmx.de";
  };

  programs.nushell = {
    enable = true;
    settings = {
    edit_mode = "vi";
    };
  };  
          
  programs.zoxide.enable = true; 
}