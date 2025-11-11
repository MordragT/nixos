{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.git;
in {
  options.mordrag.programs.git = {
    enable = lib.mkEnableOption "Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Thomas Wehmöller";
        email = "connect.mordrag@gmx.de";
      };
      signing = {
        format = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN40eH/59LSYNIaNsBfsvQYVbbpitikNRPxS5VyRyEda";
        signByDefault = true;
      };
    };
    home.packages = with pkgs; [
      comoji # emoji conventional commits
      git-cliff # generate changelogs
      git-subrepo
      # gitoxide # alternative git still wip
      onefetch # git summary
    ];
  };
}
