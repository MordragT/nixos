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
  };

  # programs.steam.gamescopeSession.args = [
  #   "-w 1920"
  #   "-h 1080"
  # ];
}
