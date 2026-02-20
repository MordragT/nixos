{
  config,
  pkgs,
  ...
}:
{
  mordrag.bluetooth.enable = true;
  mordrag.core.enable = true;
  mordrag.fonts.enable = true;
  mordrag.locale.enable = true;
  mordrag.networking.enable = true;
  mordrag.nix.enable = true;
  mordrag.pipewire.enable = true;
  mordrag.secrets.enable = true;
  mordrag.security.enable = true;
  mordrag.users.enable = true;
  mordrag.virtualisation.enable = true;

  # General
  services.displayManager.cosmic-greeter.enable = true;

  mordrag.desktop.cosmic.enable = true;
  mordrag.desktop.gnome.enable = true;
  mordrag.desktop.niri.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";

  # Networking
  networking.hostName = "tom-desktop";

  networking.hosts = {
    "127.0.0.1" = [ "tom-desktop.local" ];
  };

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
    ffmpeg-full
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
    virtualbox.host = {
      # enable = true;
      #headless = true;
      #enableHardening = false;
    };
    docker.enable = true;
    # waydroid.enable = true;
    # libvirtd.enable = true;
    # multipass.enable = true;
  };

  # workaround for virtualbox
  boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];
}
