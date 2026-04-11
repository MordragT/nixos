{
  mordrag = {
    core.enable = true;

    programs = {
      firefox.enable = true;
      mangohud.enable = true;
      nushell.enable = true;
      vscode.enable = true;
      zed-editor.enable = true;
      zen-browser.enable = true;
    };

    # TODO move gnome packages into users.users.xxx.packages
    gnome.enable = true;
  };
}
