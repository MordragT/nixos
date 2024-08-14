{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.steam;
in {
  options.mordrag.programs.steam = {
    enable = lib.mkEnableOption "Steam";
    package = lib.mkOption {
      description = "Package to use";
      default =
        if cfg.gameFixes
        then pkgs.steam
        else pkgs.steam-small;
      type = lib.types.package;
    };
    controller = lib.mkOption {
      description = "Enable Steam controller";
      default = true;
      type = lib.types.bool;
    };
    compatPackages = lib.mkOption {
      description = "Enable compatibility tools";
      default = [];
      type = lib.types.listOf lib.types.package;
    };
    gameFixes = lib.mkOption {
      description = "Enable game specific fixes";
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = cfg.controller;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      package = cfg.package.override {
        extraEnv = {
          MANGOHUD = false;
          MANGOHUD_DLSYM = true;
        };
        extraLibraries = pkgs:
          with pkgs; [
            libpulseaudio
            gamemode
          ];
      };
      extraCompatPackages = cfg.compatPackages;
    };
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings.general = {
        renice = 10;
        inhibit_screensaver = 0;
      };
    };
    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };

    environment.etc = lib.mkIf cfg.gameFixes {
      # Crusader Kings 3
      "ssl/certs/f387163d.0".source = "${pkgs.cacert.unbundled}/etc/ssl/certs/Starfield_Class_2_CA.crt";
    };

    networking.firewall = lib.mkIf cfg.gameFixes {
      # https://help.steampowered.com/en/faqs/view/2EA8-4D75-DA21-31EB
      allowedTCPPortRanges = [
        {
          from = 27015;
          to = 27050;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 27015;
          to = 27050;
        }
      ];
    };

    environment.systemPackages = lib.optional cfg.controller pkgs.sc-controller;
  };
}
