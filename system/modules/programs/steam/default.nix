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
    compatPackages = lib.mkOption {
      description = "Enable compatibility tools";
      default = [];
      type = lib.types.listOf lib.types.package;
    };
  };

  #SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0 %command% +exec mordrag.cfg -high -sdl_displayindex 1 -sdlaudiodriver pipewire -nojoy

  config = lib.mkIf cfg.enable {
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      dedicatedServer.openFirewall = false;
      package = pkgs.steam.override {
        # extraEnv = {
        #   MANGOHUD = true;
        #   MANGOHUD_DLSYM = true;
        # };
        extraLibraries = pkgs:
          with pkgs; [
            # Plague Inc Evolved
            libGLU
            # BattleBlock Theater
            sdl2-compat
          ];
        # extraPackages = pkgs:
        #   with pkgs; [
        #     gamemode
        #   ];
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
      package = pkgs.gamescope;
      # args = [
      #   "-W 2560"
      #   "-H 1440"
      #   "-w 1920"
      #   "-h 1080"
      #   "-r 120"
      #   "-f"
      #   "--rt"
      #   "--display-index 1"
      #   "--immediate-flips"
      #   "--backend sdl"
      #   "--mangoapp"
      # ];
    };

    environment.etc = {
      # Crusader Kings 3
      "ssl/certs/f387163d.0".source = "${pkgs.cacert.unbundled}/etc/ssl/certs/Starfield_Class_2_CA.crt";
    };
  };
}
