{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.core;
in {
  options.mordrag.core = {
    enable = lib.mkEnableOption "Enable core settings";
  };

  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      enable = true;
      x11.enable = true;
      # gtk.enable = true;

      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 24;
    };

    nix = {
      extraOptions = "experimental-features = nix-command flakes";
      # warning: ignoring the client-specified setting 'trusted-public-keys', because it is a restricted setting and you are not a trusted user
      # settings = {
      #   substituters = [
      #     "https://nix-community.cachix.org"
      #     "https://cache.nixos.org/"
      #   ];
      #   trusted-public-keys = [
      #     "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      #     "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      #   ];
      # };
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
    };

    programs.nix-index.enable = true;
    programs.command-not-found.enable = false;

    home.packages = with pkgs; [
      cachix # nix binary hosting
      cntr # container debugging for nix derivations
      nix-tree # browse nix store path dependencies
      nix-init
      nix-melt
      nix-du
      graphviz # needed by nix-du
    ];

    xdg = {
      enable = true;
      userDirs.enable = true;
      # mimeApps.enable = true;
      # configHome = "~/.config";
      # cacheHome = "/run/user/1000/.cache";
      # dataHome = "~/.local/share";
      # stateHome = "~/.local/state";
    };
  };
}
