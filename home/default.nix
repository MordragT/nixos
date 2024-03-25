{...}: {
  imports = [
    ./cli
    ./gnome
    ./programs
    ./free.nix
    ./gaming.nix
    ./nix.nix
    ./unfree.nix
  ];

  xdg = {
    enable = true;
    userDirs.enable = true;
    # configHome = "~/.config";
    # cacheHome = "/run/user/1000/.cache";
    # dataHome = "~/.local/share";
    # stateHome = "~/.local/state";
  };
}
