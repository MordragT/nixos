{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.lsfg-vk;
in {
  options.mordrag.programs.lsfg-vk = {
    enable = lib.mkEnableOption "LSFG-VK";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lsfg-vk-ui
      lsfg-vk
    ];

    environment.etc."vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json".source = "${pkgs.lsfg-vk}/share/vulkan/implicit_layer.d/VkLayer_LS_frame_generation.json";
  };
}
