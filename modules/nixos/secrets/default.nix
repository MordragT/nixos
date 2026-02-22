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
    hostPubkey = lib.mkOption {
      type = lib.types.str;
      description = "Public key of the host, used for encrypting secrets for this host.";
    };
  };

  config = lib.mkIf cfg.enable {
    vaultix = {
      settings = {
        inherit (cfg) hostPubkey;
      };

      secrets.github-mcp-token = {
        file = ./github-mcp-token.age;
        owner = config.users.users.tom.name;
      };
    };
  };
}
