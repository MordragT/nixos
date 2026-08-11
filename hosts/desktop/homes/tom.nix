{
  mordrag = {
    core.enable = true;

    programs = {
      # broken bottles.enable = true;
      firefox.enable = true;
      nushell.enable = true;
      zed-editor.enable = true;
    };

    # TODO move gnome packages into users.users.xxx.packages
    gnome.enable = true;
  };

  programs.chromium.enable = true;
}
