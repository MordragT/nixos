{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez; #pkgs.bluez5-experimental;
    powerOnBoot = false;

    settings = {
      General = {
        # Name = "Hello";
        # ControllerMode = "dual";
        # FastConnectable = "true";
        Experimental = "true";
      };
      # Policy = {
      #   AutoEnable = "true";
      # };
    };
  };
}
