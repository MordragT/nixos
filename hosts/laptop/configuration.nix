{
  mordrag = {
    boot.enable = true;
    desktop.cosmic = {
      enable = true;
      greeter = true;
    };
    disks = {
      enable = true;
      zram = true;
      mainPool = {
        devices.main = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00BL7_S64KNF0T710767";
      };
    };
    hardware.intel-i7-1260p = true;
    networking = {
      enable = true;
      lanMac = "TODO";
      wlanMac = "TODO";
    };
    platform.enable = true;
    programs = {
      git.enable = true;
      gnome-disks.enable = true;
      nautilus.enable = true;
    };
    state = {
      enable = true;
      presets.full = true;
    };
    users = {
      enable = true;
      main = "tom";
    };
  };

  environment.etc = {
    machine-id.source = "/nix/state/system/config/machine-id";
  };
}
