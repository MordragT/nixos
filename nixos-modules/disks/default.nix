{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.disks;

  raid = lib.mkOption {
    type = lib.types.enum [
      "single"
      "raid0"
      "raid1"
      "raid10"
      "raid5"
      "raid6"
    ];
    default = "single";
    description = "BTRFS RAID profile for data and metadata when using multiple devices.";
  };

  devices = lib.mkOption {
    type = with lib.types; attrsOf str;
    description = ''
      The disk devices that the raid is composed of (use `/dev/disk/by-id/`).
      The primary device of the raid has to be specified via `main`.
    '';
    example = {
      main = "/dev/disk/by-id/nvme-SAMSUNG_MZQL21T9HCJR-00A07_S64GNE0R700414";
      disk2 = "/dev/disk/by-id/nvme-SAMSUNG_MZQL21T9HCJR-00A07_S64GNE0R711075";
    };
  };
in
{
  options.mordrag.disks = {
    enable = lib.mkEnableOption "Disks";
    zram = lib.mkEnableOption "Zram";

    rootSize = lib.mkOption {
      type = lib.types.str;
      default = "10%";
      description = "Size of the root tmpfs partition.";
      example = "2G";
    };

    bootSize = lib.mkOption {
      type = lib.types.str;
      default = "500M";
      description = "Size of the boot partition.";
      example = "1G";
    };

    swapSize = lib.mkOption {
      type = lib.types.str;
      default = "4G";
      description = "Size of the swap partition.";
      example = "8G";
    };

    swapWriteBackSize = lib.mkOption {
      type = lib.types.str;
      default = "2G";
      description = "Size of the zram swap writeback device.";
      example = "8G";
    };

    mainPool = lib.mkOption {
      type = lib.types.submodule {
        options = {
          inherit raid devices;
        };
      };
    };

    pools = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            inherit raid devices;
            subvolumes = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything; # or lib.types.attrs to be simpler
              default = { };
              description = "Disko subvolume definitions for this pool.";
            };
          };
        }
      );
      default = { };
      description = "Additional pools";
    };
  };

  imports = [
    inputs.disko.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.mainPool.devices ? main;
        message = ''
          The `devices` option has to have atleast a main device,
          which denotes the disk where the BOOT and ESP partition are created on.
        '';
      }
    ]
    ++ lib.map (pool: {
      assertion = pool.devices ? main;
      message = ''
        The `devices` option has to have atleast a main device,
        which denotes the first device in the RAID pool.
      '';
    }) (lib.attrValues cfg.pools);

    swapDevices = [
      {
        device = "/dev/disk/by-label/disk-main-swap";
      }
    ];

    # according to this https://github.com/systemd/systemd/issues/16708
    # systemd will skip zram swaps when hibernating, so as long as i keep
    # a traditional swap I should be gucci
    zramSwap = {
      enable = cfg.zram;
      writebackDevice = "/dev/disk/by-label/disk-main-swap-writeback";
    };

    boot.kernel.sysctl = lib.mkIf cfg.zram {
      # According to https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
      # these values are best of zram swap
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    disko.devices =
      let
        mkDiskLabels =
          poolName: devices:
          lib.map (deviceName: "/dev/disk/by-partlabel/${poolName}-${deviceName}") (lib.attrNames devices);

        mkDisk =
          poolName: deviceName: device:
          let
            name = "${poolName}-${deviceName}";
          in
          {
            ${name} = {
              inherit device;
              type = "disk";

              content = {
                type = "gpt";
                partitions.data = {
                  inherit name;
                  size = "100%";
                };
              };
            };
          };

        mkPartitionedPool =
          partitions: poolName: pool:
          let
            mkPoolDisk = mkDisk poolName;
            mainDevice = pool.devices.main;
            additionalDevices = builtins.removeAttrs pool.devices [ "main" ];
            raidDeviceLabels = mkDiskLabels poolName additionalDevices;
          in
          (lib.mapAttrs mkPoolDisk additionalDevices)
          # Main should be evaluated last
          // {
            # Just use poolName as label for the main device.
            ${poolName} = {
              device = mainDevice;
              type = "disk";

              content = {
                type = "gpt";
                partitions = {
                  data = {
                    name = "data";
                    size = "100%";
                    content = {
                      inherit (pool) subvolumes;
                      type = "btrfs";
                      extraArgs =
                        lib.optionals (builtins.length raidDeviceLabels > 0) [
                          "-f"
                          "-d"
                          pool.raid
                          "-m"
                          pool.raid
                        ]
                        ++ raidDeviceLabels;
                    };
                  };
                }
                // partitions;
              };
            };
          };

        mkPool = mkPartitionedPool { };
      in
      {
        nodev."/" = {
          fsType = "tmpfs";
          mountOptions = [
            "defaults"
            "size=${cfg.rootSize}"
            "mode=755"
          ];
        };

        disk =
          (mkPartitionedPool
            {
              boot = {
                type = "EF00";
                name = "boot";
                size = cfg.bootSize;
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              swap = {
                name = "swap";
                size = cfg.swapSize;
                content = {
                  type = "swap";
                  resumeDevice = true;
                };
              };

              swapWriteback = {
                name = "swap-writeback";
                size = cfg.swapWriteBackSize;
              };
            }
            "main"
            (
              cfg.mainPool
              // {
                subvolumes = {
                  nix = {
                    type = "filesystem";
                    mountpoint = "/nix";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                  };
                  state = {
                    type = "filesystem";
                    mountpoint = "/state";
                    mountOptions = [
                      "noatime"
                      "compress=zstd"
                    ];
                  };
                };
              }
            )
          )
          // lib.mergeAttrsList (lib.attrValues (lib.mapAttrs mkPool cfg.pools));
      };

    fileSystems = {
      "/nix".neededForBoot = true;
      "/state".neededForBoot = true;
    };
  };
}
