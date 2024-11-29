{
  lib,
  config,
  pkgs,
  ...
}: {
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "tom-server";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  nix.settings = {
    substituters = ["https://store.local"];
    trusted-public-keys = ["store.local:ohyp4iA+P1zKhD/nXWjrQtCB6+e69d/vgLuWD3/mnZ8="];
  };

  mordrag.programs.steam = {
    enable = false;
    gameFixes = false;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
}
