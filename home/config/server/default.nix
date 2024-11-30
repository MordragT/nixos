{pkgs, ...}: {
  imports = [
    ../base
  ];

  mordrag.programs.git.enable = true;
  mordrag.programs.helix.enable = true;
  mordrag.programs.nushell.enable = true;
  mordrag.programs.vscode.enable = true;

  programs.chromium.enable = true;

  home.packages = with pkgs; [
    loupe
    showtime
    papers
  ];
}
