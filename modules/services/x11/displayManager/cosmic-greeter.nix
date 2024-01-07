{
  config,
  lib,
  pkgs,
  ...
}: let
  dmcfg = config.services.xserver.displayManager;
  cfg = dmcfg.cosmic-greeter;
  cosmic-greeter = pkgs.cosmic-greeter;
  cage = pkgs.cage;
in
  with lib; {
    options.services.xserver.displayManager.cosmic-greeter = {
      enable = mkEnableOption "Cosmic greeter service";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [
        cosmic-greeter
      ];

      services.greetd = {
        enable = true;
        settings = {
          # TODO cosmic-greeter does not allow custom session directories
          default_session.command = "${cage}/bin/cage -s -- ${cosmic-greeter}/bin/cosmic-greeter";
        };
      };
    };
  }
