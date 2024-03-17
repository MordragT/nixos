{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "tom-server";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  # needed for protonvpn
  # https://github.com/NixOS/nixpkgs/issues/294750
  programs.nm-applet.enable = true;

  environment.systemPackages = with pkgs; [
    protonvpn-gui
  ];

  # programs.steam.gamescopeSession.args = [
  #   "-w 1920"
  #   "-h 1080"
  # ];
}
