{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.secrets;
in
{
  options.mordrag.secrets = {
    enable = lib.mkEnableOption "Secrets";
  };

  config = lib.mkIf cfg.enable {
    classified = {
      keys.first = "/nix/state/system/config/key";
      files = {
        pia.encrypted = ./pia.enc;
        github-mcp-token = {
          encrypted = ./github-mcp-token.enc;
          user = config.users.users.tom.name;
        };
      };
    };
  };
}
