{
  mordrag.hosts."tom-beacon" = {
    system = "x86_64-linux";
    stateVersion = "26.05";
    modules = [
      {
        mordrag = {
          boot.enable = true;
          disks = {
            enable = true;
            zram = true;
            swapSize = "6G";
            swapWritebackSize = "2G";
            mainPool = {
              raid = "raid0";
              devices = {
                main = "/dev/disk/by-id/ata-SanDisk_SD8SNAT-256G-1006_162648422867";
                disk0 = "/dev/disk/by-id/ata-Crucial_CT120M500SSD1_14030963D25A";
              };
            };
          };
          hardware.intel-n4100 = true;
          networking = {
            enable = true;
            lanMac = "84:39:be:67:f5:ae";
            wlanMac = "5c:5f:67:3a:d9:aa";
          };
          platform.enable = true;
          programs = {
            git.enable = true;
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
    ];

    homes.tom = {
      mordrag = {
        core.enable = true;
        programs = {
          nushell.enable = true;
        };
      };
    };
  };
}
