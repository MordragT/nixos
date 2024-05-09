{...}: {
  imports = [
    ./config
    ./modules
  ];

  mordrag.programs.git.enable = true;
  mordrag.programs.helix.enable = true;
}
