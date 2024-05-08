{...}: {
  fileSystems = {
    "/nix/state".neededForBoot = true;
  };

  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=10%"
        "mode=755"
      ];
    };

    nodev."/home/tom" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=20%"
        "mode=777"
      ];
    };

    disk.main = {
      imageSize = "20G";
      device = "/dev/sda";
      type = "disk";

      content = {
        type = "gpt";
        partitions.boot = {
          type = "EF00";
          name = "boot";
          size = "500M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        partitions.swap = {
          size = "4G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
        partitions.data = {
          size = "100%";
          content = {
            type = "btrfs";
            subvolumes.nix = {
              type = "filesystem";
              mountpoint = "/nix";
              mountOptions = [
                "noatime"
                "compress=zstd"
              ];
            };
            subvolumes.state = {
              type = "filesystem";
              mountpoint = "/nix/state";
              mountOptions = [
                "noatime"
                "compress=zstd"
              ];
            };
          };
        };
      };
    };
  };
}
