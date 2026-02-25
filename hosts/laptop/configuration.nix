_: {
  mordrag = {
    boot.enable = true;
    disks = {
      enable = true;
      mainPool = {
        devices.main = "/dev/disk/by-id/nvme-SAMSUNG_MZVL2512HCJQ-00BL7_S64KNF0T710767";
      };
    };
    desktop.cosmic = {
      enable = true;
      greeter = true;
    };
    hardware.intel-i7-1260p = true;
    platform.enable = true;
    programs = {
      gnome-disks.enable = true;
      nautilus.enable = true;
    };
    secrets = {
      enable = false;
      # hostPubkey = TODO;
    };
  };
}
