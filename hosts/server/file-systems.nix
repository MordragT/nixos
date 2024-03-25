{...}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7686565f-995a-4cf9-8b58-19b6a7dd22ae";
    fsType = "f2fs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/558C-F05C";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/89f26c8e-14ef-4fac-a379-96f538de5ef8";}];
}
