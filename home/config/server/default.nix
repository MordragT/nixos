{pkgs, ...}: {
  imports = [
    ../base
  ];

  # mordrag.programs.firefox.enable = true;
  mordrag.programs.git.enable = true;
  mordrag.programs.helix.enable = true;
  mordrag.programs.nushell.enable = true;
  mordrag.programs.vscode.enable = true;
  mordrag.programs.zen-browser.enable = true;

  home.packages = with pkgs; [
    loupe
    showtime
    papers
  ];
}
