{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp39s0";
  };

  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "tom-desktop";
  # https://github.com/NixOS/nixpkgs/issues/180175
  # systemd.network.wait-online.anyInterface = true;
  # systemd.network.wait-online.timeout = 5;

  # chaotic.mesa-git = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     intel-compute-runtime
  #     intel-media-driver
  #     intel-vaapi-driver
  #   ];
  # };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
      onevpl-intel-gpu
    ];
  };

  environment.systemPackages = [pkgs.intel-gpu-tools pkgs.ffmpeg-vpl];

  security.wrappers.intel_gpu_top = {
    source = "${pkgs.intel-gpu-tools}/bin/intel_gpu_top";
    owner = "root";
    group = "wheel";
    permissions = "0750";
    capabilities = "cap_perfmon=ep";
  };

  services.comfyui = {
    enable = true;
    # intel arc letzze goo ... soon hopefully
    extraArgs = "--use-pytorch-cross-attention --highvram";
    package = pkgs.comfyui.override {gpuBackend = "xpu";};
  };

  # programs.gamescope.args = [
  #   "-W 2560"
  #   "-H 1440"
  #   "-w 1920"
  #   "-h 1080"
  #   "-r 120"
  #   "-f"
  #   "--rt"
  #   "--display-index 1"
  #   "--immediate-flips"
  # ];
}
