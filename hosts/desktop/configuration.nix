_: {
  mordrag = {
    bluetooth.enable = true;
    boot = {
      enable = true;
      secure-boot = true;
      thp = true;
      v4l2loopback = true;
    };
    core.enable = true;
    desktop = {
      cosmic.enable = true;
      gnome.enable = true;
      niri.enable = true;
    };
    fonts.enable = true;
    hardware = {
      amd-r5-2600 = true;
      intel-arc-a750 = true;
    };
    locale.enable = true;
    networking.enable = true;
    nix.enable = true;
    pipewire.enable = true;
    secrets = {
      enable = true;
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICS5VqBeNWhTolWxS01+dpg3zcw5OMRaSF5Ylwk1fn1v root@tom-desktop";
    };
    security.enable = true;
    users.enable = true;
    virtualisation.enable = true;
    # TODO zram.enable = true;
  };

  # General
  services.displayManager.cosmic-greeter.enable = true;
}
