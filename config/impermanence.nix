{...}: {
  environment.persistence."/nix/state" = {
    hideMounts = true;
    users.tom = {
      directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
        ".cache"
        ".cargo"
        ".config/blender"
        ".config/Code"
        ".config/comoji"
        {
          directory = ".config/dconf";
          mode = "0700";
        }
        ".config/discord"
        ".config/easyeffects"
        ".config/geary"
        ".config/gnome-boxes"
        {
          directory = ".config/gnome-control-center";
          mode = "0700";
        }
        ".config/goa-1.0"
        ".docker"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        ".local/share/bottles"
        ".local/share/direnv"
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        {
          directory = ".local/share/Steam";
          mode = "0700";
          # method = "symlink"; # only in home module
        }
        ".local/state/home-manager"
        ".local/state/nix"
        ".minecraft"
        ".mozilla"
        ".ollama"
        {
          directory = ".ssh";
          mode = "0700";
        }
        ".steam"
        ".vscode"
      ];
      files = [
        ".config/gnome-initial-setup-done"
        ".config/monitors.xml"
        ".config/nushell/history.txt"
      ];
    };
  };
}
