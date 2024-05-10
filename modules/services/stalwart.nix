{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.services.stalwart;
in {
  options.mordrag.services.stalwart = {
    enable = lib.mkEnableOption "Stalwart";
  };

  config = lib.mkIf cfg.enable {
    services.stalwart-mail.enable = true;
    services.stalwart-mail.settings = {
      server.hostname = "mail.localhost";
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
          bind = "127.0.0.1:8080";
        };
      };
    };
  };
}
