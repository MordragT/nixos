{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.steam;
in
{
  options.mordrag.programs.steam = {
    enable = lib.mkEnableOption "Steam";
    compatPackages = lib.mkOption {
      description = "Enable compatibility tools";
      default = [ ];
      type = lib.types.listOf lib.types.package;
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag.users.main.extraGroups = [ "gamemode" ];

    hardware.steam-hardware.enable = true;

    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        dedicatedServer.openFirewall = false;
        extraCompatPackages = cfg.compatPackages;
      };
      gamemode = {
        enable = true;
        enableRenice = true;
        settings.general = {
          renice = 10;
          inhibit_screensaver = 0;
        };
      };
    };
    environment.etc = {
      # Crusader Kings 3
      "ssl/certs/f387163d.0".source = "${pkgs.cacert.unbundled}/etc/ssl/certs/Starfield_Class_2_CA.crt";
    };
  };
}
