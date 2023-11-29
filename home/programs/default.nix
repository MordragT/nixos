{pkgs, ...}: {
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

  programs.eza.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_frappe";
    };
  };

  programs.zoxide.enable = false;
}
