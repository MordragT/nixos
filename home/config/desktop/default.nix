{...}: {
  imports = [
    ../base
  ];

  mordrag.programs.bottles.enable = true;
  mordrag.programs.firefox.enable = true;
  mordrag.programs.git.enable = true;
  mordrag.programs.helix.enable = true;
  mordrag.programs.mangohud.enable = true;
  mordrag.programs.nushell.enable = true;
  mordrag.programs.nvim.enable = true;
  mordrag.programs.obs.enable = true;
  mordrag.programs.thunderbird.enable = true;
  mordrag.programs.vscode.enable = true;
  mordrag.programs.zed-editor.enable = true;
  mordrag.programs.zen-browser.enable = true;
  mordrag.programs.zsh.enable = true;

  programs.chromium = {
    enable = true;
  };

  mordrag.collection.cli.enable = true;
  mordrag.collection.free.enable = true;
  mordrag.collection.gaming.enable = true;
  mordrag.collection.gnome.enable = true;
  mordrag.collection.nonfree.enable = true;
}
