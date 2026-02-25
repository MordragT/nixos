_: {
  mordrag.environment.state = {
    enable = true;
    presets.full = true;
  };

  environment.etc = {
    machine-id.source = "/nix/state/system/config/machine-id";
  };

  systemd.tmpfiles.rules = [
    # "L /home/tom/.config/monitors.xml - - - - /nix/state/users/tom/config/monitors.xml"
    # "L /home/tom/.config/mimeapps.list - - - - /nix/state/users/tom/config/mimeapps.list"
  ];
}
