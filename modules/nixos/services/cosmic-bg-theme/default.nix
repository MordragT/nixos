{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.services.cosmic-bg-theme;
in
{
  options.mordrag.services.cosmic-bg-theme = {
    enable = lib.mkEnableOption "COSMIC Background Theme Extension";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.cosmic-bg-theme = {
      description = "COSMIC Background Theme Extension";

      documentation = [ "man:cosmic-ext-bg-theme(1)" ];
      partOf = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.cosmic-ext-bg-theme}/bin/cosmic-ext-bg-theme";
      };
    };
  };
}
