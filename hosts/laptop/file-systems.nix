_: {

  fileSystems = {
    "/" = {
      device = "none";
      neededForBoot = true;
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=20%"
        "mode=755"
      ];
    };

    "/home/tom" = {
      device = "none";
      neededForBoot = true;
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=40%"
        "mode=777"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    # ssd
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
      ];
    };

    # hdd
    "/nix/state" = {
      device = "/dev/disk/by-label/state";
      neededForBoot = true;
      fsType = "btrfs";
      options = [
        "noatime"
        "compress=zstd"
        "autodefrag"
      ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}
