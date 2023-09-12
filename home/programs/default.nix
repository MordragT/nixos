{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
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

  programs.git = {
    enable = true;
    userName = "Thomas Wehmöller";
    userEmail = "connect.mordrag@gmx.de";
  };
  home.packages = with pkgs; [ git-subrepo ];

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_frappe";
    };
  };

  programs.zoxide.enable = false;

}
