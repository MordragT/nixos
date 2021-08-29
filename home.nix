{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tom";
  home.homeDirectory = "/home/tom";

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
  
  home.packages = with pkgs; [
    # No GTK Core Apps
    
    # Rust Apps
    helix # Kakoune style editor
    bottom # htop alike   
    macchina # neofetch alike
    contrast # gtk check contrast
    fractal # gtk matrix messaging
    markets # gtk crypto market prices
    just # make alike
    navi # interactive cheat sheet
    tealdeer # tldr
    du-dust # file system usage
    watchexec # executes command on modifications
    tokei # count lines of code
    onefetch # git summary 
    grex # create regular expressions
    bandwhich # display network utilization
    hexyl # hex viewer
    zellij # terminal workspace
    hyperfine # benchmarking
    gping # ping with a graph
    sd # sed and awk replacement using regex   
    fd # find replacement
    broot # tree replacement
    
    # Downloads        
    megasync # File sharing
    qbittorrent
    
    # IT Security & Reverse Engineering
    wireshark
    cutter    
  
    # Development
    javacc
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
  ];
  
  xdg = {
    enable = true;
  };
  
  home.sessionVariables = {
    EDITOR="hx";
  };

  pam.sessionVariables = with config.home; sessionVariables // {
    XDG_CONFIG_HOME =  "${homeDirectory}/.config";
    XDG_CACHE_HOME = "${homeDirectory}/.cache";
    XDG_DATA_HOME = "${homeDirectory}/.local/share";
    XDG_STATE_HOME = "${homeDirectory}/.local/state";
    XDG_DATA_DIRS = "/usr/share:/usr/local/share:${homeDirectory}/.local/share/:${homeDirectory}/.nix-profile/share";
  };
  
  programs.nushell = {
    enable = true;
    settings = {
      edit_mode = "vi";
    };
  };  
  
  programs.git = {
    enable = true;
    userName = "Thomas Wehmöller";
    userEmail = "connect.mordrag@gmx.de";
  };
    
  programs.obs-studio.enable = true;
    
  # Rust Programs
  
  programs.bat.enable = true;
  programs.exa.enable = true;
  programs.zoxide.enable = true;
  
}
