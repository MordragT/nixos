{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez; #pkgs.bluez5-experimental;
    powerOnBoot = false;
  };
}
