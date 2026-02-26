_: {
  mordrag = {
    boot = {
      enable = true;
      secure-boot = true;
      thp = true;
      v4l2loopback = true;
    };
    desktop = {
      cosmic = {
        enable = true;
        greeter = true;
      };
      gnome.enable = true;
      niri.enable = true;
    };
    hardware = {
      amd-r5-2600 = true;
      intel-arc-a750 = true;
    };
    platform.enable = true;
    secrets = {
      enable = true;
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICS5VqBeNWhTolWxS01+dpg3zcw5OMRaSF5Ylwk1fn1v root@tom-desktop";
    };
  };
}
