{...}: {
  imports = [
    ../base
  ];

  mordrag.programs.firefox.enable = true;
  mordrag.programs.git.enable = true;
  mordrag.programs.helix.enable = true;
  mordrag.programs.mangohud.enable = true;
  mordrag.programs.nushell.enable = true;
  mordrag.programs.vscode.enable = true;
  mordrag.programs.zsh.enable = true;

  mordrag.collection.cli.enable = true;
  mordrag.collection.free.enable = true;
  mordrag.collection.gnome.enable = true;
  mordrag.collection.nonfree.enable = true;
}
