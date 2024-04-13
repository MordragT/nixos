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
        partitions.data = {
          end = "-4G";
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
        partitions.swap = {
          size = "100%";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
      };
    };
  };
}
