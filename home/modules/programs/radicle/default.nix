{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.programs.radicle;
in {
  options.mordrag.programs.radicle = {
    enable = lib.mkEnableOption "Radicle";
  };

  config = lib.mkIf cfg.enable {
    # programs.radicle = {
    #   enable = true;
    #   settings.node.alias = "mordrag";
    # };

    # services.radicle.node enables this,
    # but the module doesn't work, as the settings are not sufficient to create a profile
    # and therefor useless as they have to be created with the cli then.
    programs.radicle.enable = false;

    home.packages = with pkgs; [
      radicle-tui
      radicle-desktop
    ];

    # wait for 1.6 to be able to set credentials via systemd
    # services.radicle.node = {
    #   enable = true;
    #   # environment.SSH_AUTH_SOCK = "/run/user/1000/gcr/ssh";
    # };
  };
}
