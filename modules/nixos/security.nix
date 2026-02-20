{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.security;
in {
  options.mordrag.security = {
    enable = lib.mkEnableOption "Security";
  };

  config = lib.mkIf cfg.enable {
    security.sudo-rs.enable = true;
    security.sudo.enable = false;

    security.acme.defaults.email = "contact.mordrag+acme@gmail.de";
    security.acme.acceptTerms = true;
  };
}
