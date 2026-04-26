{
  mordrag = {
    core.enable = true;

    programs = {
      firefox.enable = true;
      nushell.enable = true;
      zed-editor.enable = true;
      zen-browser.enable = true;
    };

    # TODO move gnome packages into users.users.xxx.packages
    gnome.enable = true;
  };

  programs.chromium.enable = true;
}
