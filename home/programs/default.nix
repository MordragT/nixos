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
  programs.exa.enable = true;

  programs.git = {
    enable = true;
    userName = "Thomas Wehmöller";
    userEmail = "connect.mordrag@gmx.de";
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_frappe";
    };
  };

  programs.zoxide.enable = true;

}
