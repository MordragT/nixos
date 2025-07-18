{config, ...}: {
  classified.keys.first = "/nix/state/system/config/key";
  classified.files.pia.encrypted = ./pia.enc;
  classified.files.github-mcp-token = {
    encrypted = ./github-mcp-token.enc;
    user = config.users.users.tom.name;
  };
}
