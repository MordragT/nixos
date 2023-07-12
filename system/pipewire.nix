{ pkgs, ... }:
{
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


  # environment.etc = {
  #   "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  #     bluez_monitor.enabled = true;
  #     bluez_monitor.properties = {
  #       ["bluez5.enable-sbc-xq"] = true,
  #       ["bluez5.enable-msbc"] = true,
  #       ["bluez5.enable-hw-volume"] = true,
  #       ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
  #       ["bluez5.codecs"] = "[ sbc sbc_xq aac ldac aptx aptx_hd aptx_ll ]"
  #       ["bluez5.a2dp.ldac.quality"] = "auto",
  #       ["bluez5.a2dp.aac.bitratemode"] = 5
  #       ["bluez5.auto-connect"] = "[ hfp_hf hsp_hs a2dp_sink ]"
  #     }
  #   '';
  # };

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
