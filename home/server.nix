{...}: {
  imports = [
    ./config
    ./modules
  ];

  mordrag.programs.firefox.enable = true;
  mordrag.programs.git.enable = true;
  mordrag.programs.helix.enable = true;
  mordrag.programs.nushell.enable = true;
  mordrag.programs.vscode.enable = true;
}
