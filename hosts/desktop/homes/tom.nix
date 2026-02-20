_: {
  mordrag = {
    core.enable = true;

    programs = {
      bottles.enable = true;
      firefox.enable = true;
      git.enable = true;
      helix.enable = true;
      mangohud.enable = true;
      niri.enable = true;
      nushell.enable = true;
      nvim.enable = true;
      obs.enable = true;
      radicle.enable = true;
      thunderbird.enable = true;
      vscode.enable = true;
      zed-editor.enable = true;
      zen-browser.enable = true;
    };

    # services.espanso.enable = true;

    collection = {
      cli.enable = true;
      free.enable = true;
      gaming.enable = true;
      gnome.enable = true;
      nonfree.enable = true;
    };
  };

  programs.chromium = {
    enable = true;
  };
}
