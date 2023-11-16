{...}: {
  hardware.pulseaudio.enable = false;
  # hardware.bluetooth = {
  #   enable = true;
  #   package = pkgs.bluez5-experimental;
  # };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
}
