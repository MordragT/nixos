{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.services.evdevhook2;
  ini = pkgs.formats.ini { };

  configFile = ini.generate "evdevhook2.ini" cfg.settings;
in
{
  options.mordrag.services.evdevhook2 = {
    enable = lib.mkEnableOption "COSMIC Background Theme Extension";

    settings = lib.mkOption {
      inherit (ini) type;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.evdevhook2 = {
      after = [ "bluetooth.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-abort";
        ExecStart =
          "${pkgs.evdevhook2}/bin/evdevhook2" + lib.optionalString (cfg.settings != { }) " ${configFile}";
      };
    };
  };
}
