{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.security;
in
{
  options.mordrag.security = {
    enable = lib.mkEnableOption "Security";
  };

  config = lib.mkIf cfg.enable {
    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "contact.mordrag+acme@gmail.de";
      };
      sudo.enable = false;
      sudo-rs.enable = true;
    };
  };
}
