{
  vaultix = {
    settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICS5VqBeNWhTolWxS01+dpg3zcw5OMRaSF5Ylwk1fn1v root@tom-desktop";
  };

  mordrag = {
    boot = {
      enable = true;
      secureBoot = true;
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
    networking = {
      enable = true;
      lanMac = "30:9c:23:8a:54:c6";
      wlanMac = "14:f6:d8:b3:fd:f3";
    };
    platform.enable = true;
    users = {
      enable = true;
      main = "tom";
    };
  };

  programs.chromium.enable = true;

}
