{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mordrag.boot;
in
{
  options.mordrag.boot = {
    enable = lib.mkEnableOption "Boot";
    secure-boot = lib.mkEnableOption "Secure Boot";
    # https://www.abhik.ai/concepts/memory/transparent-huge-pages
    thp = lib.mkEnableOption "Transparent Huge Pages (THP)";
    v4l2loopback = lib.mkEnableOption "v4l2loopback";

  };

  config = lib.mkIf cfg.enable {
    # Boot Loader
    environment.systemPackages = lib.optionals cfg.secure-boot [ pkgs.sbctl ];

    boot = {
      loader = {
        systemd-boot = {
          enable = lib.mkForce false;
          editor = false;
          consoleMode = "max";
        };
        efi.canTouchEfiVariables = false;
      };

      lanzaboote = {
        enable = cfg.secure-boot;
        pkiBundle = "/var/lib/sbctl";
      };

      tmp = {
        useTmpfs = true;
        tmpfsSize = "50%";
        cleanOnBoot = true;
      };

      runSize = "25%";

      kernelPackages = pkgs.linuxPackages_latest; # pkgs.linuxPackages_cachyos-lto; #linuxPackages_latest/testing/6_7

      kernelParams = lib.optionals cfg.thp [
        # THP transparently collapses large regions of separately allocated memory
        # into hugepages which can lead to significant performance benefits.
        # By default, it only does this for processes which explicitly ask for it,
        # this makes it do that for any process
        "transparent_hugepage=always"
      ];

      kernel.sysctl = {
        # Increased to not run out of mmaps for certain games, by default 1024 * 1024
        # https://wiki.archlinux.org/title/Gaming#Increase_vm.max_map_count
        "vm.max_map_count" = 8 * 1024 * 1024;
        # https://wiki.archlinux.org/title/Gaming#Tweaking_kernel_parameters_for_response_time_consistency
        # Avoid stalls on memory allocations
        "vm.min_free_kbytes" = 128 * 1024; # default of 66 * 1024
      };

      initrd = {
        availableKernelModules = [
          "xhci_pci" # USB 3.x Controller
          "ehci_pci" # USB 2.0 Controller
          "sdhci_pci" # PCI SD/MMC Reader
          "ahci" # SATA Disks
          "nvme" # NVMe SSDs
          "usb_storage" # USB Sticks/Drives
          "usbhid" # USB Keyboard/Mouse
          "sd_mod" # SD Cards
          "sr_mod" # Optical CD/DVD
          "rtsx_usb_sdmmc" # Realtek USB SD Reader (Laptops)
        ];
        kernelModules = [ ];
      };

      extraModulePackages = lib.optionals cfg.v4l2loopback [
        config.boot.kernelPackages.v4l2loopback
      ];

      kernelModules = [
        "ntsync"
      ]
      ++ lib.optionals cfg.v4l2loopback [
        "v4l2loopback"
      ];

      extraModprobeConfig = lib.optionalString cfg.v4l2loopback ''
        options v4l2loopback devices=1 video_nr=2 card_label="Loopback Camera" exclusive_caps=1
      '';
    };
  };
}
