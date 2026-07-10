{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.services.tailscale;
in
{
  options.mordrag.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true; # trayscale gui ?
      extraSetFlags = [
        "--operator=${config.mordrag.users.main.name}"
      ];
    };

    mordrag.state.directories = [ "/var/lib/tailscale" ];
  };
}
