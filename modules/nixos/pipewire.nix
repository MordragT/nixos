{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.pipewire;
in {
  options.mordrag.pipewire = {
    enable = lib.mkEnableOption "Pipewire";
  };

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;
  };
}
