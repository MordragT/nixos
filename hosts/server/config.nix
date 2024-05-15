{
  lib,
  config,
  pkgs,
  ...
}: {
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "tom-server";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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

  nix.settings = {
    substituters = ["https://store.local"];
    trusted-public-keys = ["store.local:ohyp4iA+P1zKhD/nXWjrQtCB6+e69d/vgLuWD3/mnZ8="];
  };

  # needed for protonvpn
  # https://github.com/NixOS/nixpkgs/issues/294750
  programs.nm-applet.enable = true;
  environment.systemPackages = with pkgs; [
    protonvpn-gui
  ];

  mordrag.desktop.cosmic.enable = true;
  mordrag.programs.steam = {
    enable = false;
    gameFixes = false;
  };
  mordrag.programs.gnome-disks.enable = true;
  # mordrag.services.samba.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
}
