{
  pkgs,
  ...
}:
{
  mordrag = {
    boot = {
      enable = true;
      # TODO: this doesn't seem to work for first nixos-anywhere install
      # secureBoot = true;
      thp = true;
    };
    desktop.steamos.enable = true;
    disks = {
      enable = true;
      zram = true;
      swapSize = "12G";
      swapWritebackSize = "4G";
      mainPool.devices.main = "/dev/disk/by-id/nvme-WDC_PC_SN520_SDAPNUW-256G-1006_19321B800783";
      pools.snapshot.devices.main = "/dev/disk/by-id/ata-ST1000LM035-1RK172_WL16JC6M";
    };
    hardware.amd-r5-2400g = true;
    networking = {
      enable = true;
      lanMac = "9c:7b:ef:ae:e5:6d";
      wlanMac = "54:8c:a0:b1:5b:df";
    };
    platform.enable = true;
    programs = {
      git.enable = true;
      gnome-disks.enable = true;
      steam = {
        enable = true;
        compatPackages = [ pkgs.proton-ge-bin ];
      };
    };
    services = {
      qpad = {
        enable = true;
        port = 3000;
        openFirewall = true;
      };
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

  programs.chromium.enable = true;

  environment.systemPackages = with pkgs; [
    loupe
    showtime
    papers
  ];
}
