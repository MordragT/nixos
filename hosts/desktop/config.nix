{pkgs, ...}: {
  # General
  mordrag.desktop.cosmic.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  # Networking
  networking.hostName = "tom-desktop";
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
  # chaotic.mesa-git = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     intel-compute-runtime
  #     intel-media-driver
  #     intel-vaapi-driver
  #     onevpl-intel-gpu
  #   ];
  # };
  environment.systemPackages = with pkgs; [
    ffmpeg-vpl
    # intel-sysmon
    # nvtopPackages.intel
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
      enable = false;
      #headless = true;
      #enableHardening = false;
    };
    docker.enable = true;
    # waydroid.enable = true;
    # libvirtd.enable = true;
    # multipass.enable = true;
  };
}
