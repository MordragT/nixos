{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.valent;
in {
  options.mordrag.programs.valent = {
    enable = lib.mkEnableOption "Valent";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      valent # kde connect implementation for gnome
    ];

    networking.firewall.allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];

    networking.firewall.allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
}
