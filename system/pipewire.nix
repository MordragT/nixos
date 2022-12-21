{ ... }:
{
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  # recommended for pipewire
  security.rtkit.enable = true;

  # change default port for xonar dg
  # todo
  # environment.etc."wireplumber/main.lua.d/51-xonar-dg-default-port.lua".text = ''
  #   rule = {
  #     matches = {
  #       {
  #         { "node.name", "equals", "alsa_output.pci-0000_04_01.0.analog-stereo" },
  #       },
  #     },
  #     apply_properties = {
  #       ["node.description"] = "Laptop",
  #     },
  #   }

  #   table.insert(alsa_monitor.rules, rule)
  # '';
}
