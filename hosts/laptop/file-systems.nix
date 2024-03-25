{...}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/29a924dc-05e9-4009-a9c7-f18059cbe6af";
    fsType = "f2fs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6279-C816";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1c993eac-9840-4539-8639-2c91454ff5a4";
    fsType = "btrfs";
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];
}
