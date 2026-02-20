_: {
  mordrag.environment.state = {
    enable = true;
    targets = [
      {
        source = "/nix/state/system/config";
        destination = "/etc";
        method = "mount";
        owner = "root";
        group = "root";
        mode = "0700";
      }
      {
        source = "/nix/state/system/state";
        destination = "/var/lib";
        method = "mount";
        owner = "root";
        group = "root";
        mode = "0700";
      }
      {
        source = "/nix/state/system/variable";
        destination = "/var";
        method = "mount";
        owner = "root";
        group = "root";
        mode = "0700";
      }
      # Home
      {
        source = "/nix/state/users/tom/home";
        destination = "/home/tom";
        method = "mount";
        owner = "tom";
        group = "users";
        mode = "0700";
      }
      {
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

  environment.etc = {
    machine-id.source = "/nix/state/system/config/machine-id";
  };

  systemd.tmpfiles.rules = [
    # "L /home/tom/.config/monitors.xml - - - - /nix/state/users/tom/config/monitors.xml"
    # "L /home/tom/.config/mimeapps.list - - - - /nix/state/users/tom/config/mimeapps.list"
  ];
}
