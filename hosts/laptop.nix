{ ... }:
{
  # imports =
  #   [
  #     (modulesPath + "/installer/scan/not-detected.nix")
  #   ];
  
  hostName = "tom-laptop"; # Define your hostname.
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7686565f-995a-4cf9-8b58-19b6a7dd22ae";
      fsType = "f2fs";
    };
  
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/558C-F05C";
      fsType = "vfat";
    };
  
  swapDevices =
    [ { device = "/dev/disk/by-uuid/89f26c8e-14ef-4fac-a379-96f538de5ef8"; }
    ];
  
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  
  useDHCP = false;
  interfaces.enp2s0.useDHCP = true;
  interfaces.wlo1.useDHCP = true;
  
  # extraHosts = ''
  #   127.0.0.1 mordrag.io
  # '';
}
