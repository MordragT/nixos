{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.steam;
in {
  options = {
    mordrag.steam = {
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
  };

  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = cfg.controller;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      package = cfg.package.override {
        extraEnv = {
          MANGOHUD = true;
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
      capSysNice = true;
    };

    environment.etc = lib.mkIf cfg.gameFixes {
      # Crusader Kings 3
      "ssl/certs/f387163d.0".source = "${pkgs.cacert.unbundled}/etc/ssl/certs/Starfield_Class_2_CA.crt";
    };

    networking.firewall = lib.mkIf cfg.gameFixes {
      # Crusader Kings 3
      allowedTCPPorts = [27015 27036];
      allowedUDPPorts = [27015 27031 27032 27033 27034 27036 27036];
    };

    environment.systemPackages = [pkgs.protontricks] ++ (lib.optional cfg.controller pkgs.sc-controller);
  };
}
