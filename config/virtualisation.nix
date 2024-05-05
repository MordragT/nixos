{...}: {
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
    waydroid.enable = true;
    # libvirtd.enable = true;
    # multipass.enable = true;
  };
}
