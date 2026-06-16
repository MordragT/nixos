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
      swapSize = "32G";
      swapWritebackSize = "8G";
      mainPool = {
        devices.main = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S6Z1NJ0W535010R";
        luks = true;
      };
    };
    hardware.intel-i7-13700h = true;
    networking = {
      enable = true;
      primary = {
        name = "wlan";
        mac = "c4:3d:1a:0c:ef:4f";
      };
    };
    platform.enable = true;
    programs = {
      git.enable = true;
      gnome-disks.enable = true;
      nautilus.enable = true;
    };
    state = {
      enable = true;
    };
    users = {
      enable = true;
      main = {
        name = "tom";
        state.enable = true;
      };
    };
  };
}
