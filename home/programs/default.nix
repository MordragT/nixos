{...}: {
  imports = [
    ./firefox.nix
    ./git.nix
    ./nushell.nix
    ./obs.nix
    ./steam.nix
    ./vscode
    ./zsh.nix
  ];

  programs.bat = {
    enable = true;
    config.theme = "gruvbox-dark";
  };
  programs.chromium.enable = true;

  programs.eza.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_frappe";
    };
  };

  programs.mangohud = {
    enable = true;
    enableSessionWide = false;
    settings = {
      full = true;
      output_folder = "~/Desktop/MangoHud";
      fps_limit = [0 60 80 100 120];
      toggle_fps_limit = "Super_L+F1";
      toggle_hud = "Super_L+F3";
      toggle_logging = "Super_L+F4";
    };
  };

  programs.zoxide.enable = false;
}
