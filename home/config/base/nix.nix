{pkgs, ...}: {
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
    alejandra # nix formater: files are everywhere anyways
    cachix # nix binary hosting
    cntr # container debugging for nix derivations
    nil # nix language server
    nixd # TODO needed because of https://github.com/zed-industries/zed/issues/23368
    nix-tree # browse nix store path dependencies
    nix-init
    nix-melt
    nix-du
    graphviz # needed by nix-du
  ];
}
