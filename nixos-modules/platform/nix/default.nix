{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.platform.nix;
in
{
  options.mordrag.platform.nix = {
    enable = lib.mkEnableOption "Nix settings";
  };

  config = lib.mkIf cfg.enable {
    # when running out ouf inodes remove files under /nix/var/log/nix/drvs
    nix = {
      extraOptions = "experimental-features = nix-command flakes";

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
        use-xdg-base-directories = true;
      };
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
        dates = "weekly";
      };
    };

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      nix-ld.enable = true; # run unpatchable binaries
      nix-index.enable = true; # recommends non-installed packages
    };

    environment.systemPackages = with pkgs; [
      cachix # nix binary hosting
      cntr # container debugging for nix derivations
      nix-tree # browse nix store path dependencies
      nix-init # init nix urls
      nix-melt # inspect flake.lock
      nix-du # check nix file size
    ];
  };
}
