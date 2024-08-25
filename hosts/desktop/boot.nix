{
  config,
  lib,
  pkgs,
  ...
}: {
  # Boot Loader
  environment.systemPackages = [pkgs.sbctl];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.plymouth.enable = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # Tmpfs
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "75%";
  boot.tmp.cleanOnBoot = true;
  boot.runSize = "25%";

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest; #pkgs.linuxPackages_cachyos-lto; #linuxPackages_latest/testing/6_7
  boot.kernelParams = [
    # "i915.force_probe=!56a1"
    # "xe.force_probe=56a1"
    # https://wiki.archlinux.org/title/Gaming#Improve_clock_gettime_throughput
    # already default ?
    # "tsc=reliable"
    # "clocksource=tsc"
    "retbleed=off"
  ];
  boot.kernel.sysctl = {
    # According to https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    # these values are best of zram swap
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;

    # Increased to not run out of mmaps for certain games, by default 1024 * 1024
    # https://wiki.archlinux.org/title/Gaming#Increase_vm.max_map_count
    "vm.max_map_count" = 8 * 1024 * 1024;
    # https://wiki.archlinux.org/title/Gaming#Tweaking_kernel_parameters_for_response_time_consistency
    # Avoid stalls on memory allocations
    "vm.min_free_kbytes" = 128 * 1024; # default of 66 * 1024
  };

  # Kernel Modules
  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [
    "kvm-amd"
    "btintel"
    "v4l2loopback"
    "zenpower"
    # "amd_pstate=active" _CPC object not present and no settings in bios
  ];
  boot.blacklistedKernelModules = [
    "k10temp"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
    zenpower
  ];
}
