{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.nix;
in
{
  options.mordrag.nix = {
    enable = lib.mkEnableOption "Nix settings";
  };

  config = lib.mkIf cfg.enable {
    # when running out ouf inodes remove files under /nix/var/log/nix/drvs
    nix = {
      settings = {
        substituters = [
          "https://cache.nixos.org/"
          "https://nix-community.cachix.org"
          "https://chaotic-nyx.cachix.org/"
          "https://9lore.cachix.org"
          "https://mordrag.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
          "9lore.cachix.org-1:H2/a1Wlm7VJRfJNNvFbxtLQPYswP3KzXwSI5ROgzGII="
          "mordrag.cachix.org-1:6SOBxvzKQ/PyH4xBCXSsUvBLvQPrjNMQhd9jE3d4gWI="
        ];
        auto-optimise-store = true;
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
        dates = "weekly";
      };
    };

    programs.nix-ld.enable = true;
  };
}
