{
  config,
  pkgs,
  ...
}: {
  # General
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  mordrag.desktop.cosmic.enable = true;
  mordrag.desktop.gnome.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";

  # Networking
  networking.hostName = "tom-desktop";

  networking.hosts = {
    "127.0.0.1" = ["tom-desktop.local"];
  };

  # https://github.com/NixOS/nixpkgs/issues/180175
  # systemd.network.wait-online.anyInterface = true;
  # systemd.network.wait-online.timeout = 5;

  # Hardware Acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-compute-runtime.drivers
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
    ];
  };

  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = with pkgs; [
    ffmpeg-vpl
    # intel-sysmon
    # nvtopPackages.intel
    config.boot.kernelPackages.turbostat
  ];

  security.wrappers.intel_gpu_top = {
    source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
    owner = "root";
    group = "wheel";
    permissions = "0750";
    capabilities = "cap_perfmon=ep";
  };

  # Virtualisation
  virtualisation = {
    vmVariant.virtualisation = {
      diskSize = 2048;
      memorySize = 4096;
      cores = 4;
    };

    virtualbox.host = {
      enable = true;
      #headless = true;
      #enableHardening = false;
    };
    docker.enable = true;
    # waydroid.enable = true;
    # libvirtd.enable = true;
    # multipass.enable = true;
  };

  # workaround for virtualbox
  boot.kernelParams = ["kvm.enable_virt_at_load=0"];
}
