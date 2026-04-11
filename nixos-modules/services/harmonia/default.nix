{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.services.harmonia;
in
{
  options.mordrag.services.harmonia = {
    enable = lib.mkEnableOption "Harmonia";

    port = lib.mkOption {
      description = "Harmonia HTTP Port";
      type = lib.types.port;
    };

    secretFile = lib.mkOption {
      description = ''
        Harmonia secret file. It should contain the private key generated via:
        ```
        nix-store --generate-binary-cache-key harmonia.<domain> harmonia.secret harmonia.pub
        ```
      '';
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    services.harmonia = {
      enable = true;
      #
      signKeyPaths = [ cfg.secretFile ];
      settings = {
        bind = "127.0.0.1:${toString cfg.port}";
      };
    };

    services.caddy.virtualHosts."harmonia.${config.networking.domain}".extraConfig = ''
      import cloudflare
      encode zstd
      reverse_proxy :${toString cfg.port}
    '';
  };
}
