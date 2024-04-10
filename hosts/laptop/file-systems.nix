{...}: {
  fileSystems."/" = {
    device = "none";
    neededForBoot = true;
    fsType = "tmpfs";
    options = ["defaults" "size=50%" "mode=755"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # ssd
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/nix";
    fsType = "btrfs";
    options = [
      "noatime"
      "compress=zstd"
    ];
  };

  # hdd
  fileSystems."/nix/state" = {
    device = "/dev/disk/by-label/state";
    fsType = "btrfs";
    options = [
      "noatime"
      "compress=zstd"
      "autodefrag"
    ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];
}
