{...}: {
  environment.state = {
    enable = true;
    targets = [
      {
        # For Documents, Picutres etc.
        # Trash does not play nice with bind mounts therefore symlink
        # whups that didnt work as well probably bug in glib or something
        source = "/nix/state/users/tom/home";
        destination = "/home/tom";
        method = "mount";
        owner = "tom";
        group = "users";
        mode = "0700";
      }
      {
        # For crappy software that does not adhere to XDG
        # and likes to pollute home
        # Aswell as .cache
        source = "/nix/state/users/tom/data";
        destination = "/home/tom";
        method = "mount";
        owner = "tom";
        group = "users";
        mode = "0700";
      }
      {
        source = "/nix/state/users/tom/config";
        destination = "/home/tom/.config";
        method = "mount";
        owner = "tom";
        group = "users";
        mode = "0700";
      }
      {
        source = "/nix/state/users/tom/share";
        destination = "/home/tom/.local/share";
        method = "mount";
        owner = "tom";
        group = "users";
        mode = "0700";
      }
      {
        source = "/nix/state/users/tom/state";
        destination = "/home/tom/.local/state";
        method = "mount";
        owner = "tom";
        group = "users";
        mode = "0700";
      }
    ];
  };

  # files not yet supported by environment.state
  systemd.tmpfiles.rules = [
    "L /home/tom/.config/monitors.xml - - - - /nix/state/users/tom/config/monitors.xml"
    # bind mounting trash does not seem to work
    # "L /home/tom/.local/share/Trash - - - - /nix/state/users/tom/trash"
  ];

  # environment.persistence."/nix/state" = {
  #   hideMounts = true;
  #   users.tom = {
  #     directories = [
  #       "Desktop"
  #       "Documents"
  #       "Downloads"
  #       "Music"
  #       "Pictures"
  #       "Videos"
  #       ".cache"
  #       ".cargo"
  #       ".config/blender"
  #       ".config/Code"
  #       ".config/comoji"
  #       {
  #         directory = ".config/dconf";
  #         mode = "0700";
  #       }
  #       ".config/discord"
  #       ".config/easyeffects"
  #       ".config/geary"
  #       ".config/gnome-boxes"
  #       {
  #         directory = ".config/gnome-control-center";
  #         mode = "0700";
  #       }
  #       ".config/goa-1.0"
  #       ".docker"
  #       {
  #         directory = ".gnupg";
  #         mode = "0700";
  #       }
  #       ".local/share/bottles"
  #       ".local/share/direnv"
  #       {
  #         directory = ".local/share/keyrings";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".local/share/Steam";
  #         mode = "0700";
  #         # method = "symlink"; # only in home module
  #       }
  #       ".local/state/home-manager"
  #       ".local/state/nix"
  #       ".minecraft"
  #       ".mozilla"
  #       ".ollama"
  #       {
  #         directory = ".ssh";
  #         mode = "0700";
  #       }
  #       ".steam"
  #       ".vscode"
  #     ];
  #     files = [
  #       ".config/gnome-initial-setup-done"
  #       ".config/monitors.xml"
  #       ".config/nushell/history.txt"
  #     ];
  #   };
  # };
}
