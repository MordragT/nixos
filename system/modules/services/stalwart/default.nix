{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.services.stalwart;
in {
  options.mordrag.services.stalwart = {
    enable = lib.mkEnableOption "Stalwart";
  };

  config = lib.mkIf cfg.enable {
    services.stalwart-mail = {
      enable = true;
      package = pkgs.stalwart-mail;
      settings = {
        # server.hostname = "mail.localhost";
        server.listener = {
          smtp = {
            protocol = "smtp";
            bind = "127.0.0.1:25";
          };
          submissions = {
            protocol = "smtp";
            bind = "127.0.0.1:587";
            tls.implicit = true;
          };
          imaptls = {
            protocol = "imap";
            bind = "127.0.0.1:993";
            tls.implicit = true;
          };
          management = {
            protocol = "http";
            bind = "127.0.0.1:8050";
          };
        };
        authentication.fallback-admin = {
          user = "admin";
          secret = "$6$bMyXd7NPiO./sD/f$enBP8XmgvHDiJh35ObyRVCPOrsScFI/AZL/mcIhACbqNAHKOkQLSjhlAvRanjNj9buWwB4uQxSLtqLRhBY5x/.";
        };
      };
    };
  };
}
