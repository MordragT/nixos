{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.rclone;
in
{
  options.mordrag.programs.rclone = {
    enable = lib.mkEnableOption "Rclone";
  };

  config = lib.mkIf cfg.enable {
    # classified.files.rclone-mega.encrypted = ./mega.enc;

    programs.rclone = {
      enable = true;
      remotes.mega = {
        config = {
          type = "mega";
          user = "...";
        };
        # secrets.password = "/var/secrets/rclone-mega";
      };
    };
  };
}
