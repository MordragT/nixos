{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.git;
in
{
  options.mordrag.programs.git = {
    enable = lib.mkEnableOption "Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      config = {
        alias = {
          ci = "commit -m";
          co = "checkout";
          l = "log --oneline";
          ll = "log";
          s = "status";
        };
        core = {
          editor = "${pkgs.helix}/bin/hx";
          pager = "${pkgs.delta}/bin/delta";
        };
        init.defaultBranch = "main";
        user = {
          email = "connect.mordrag@gmx.de";
          name = "Thomas Wehmöller";
          signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN40eH/59LSYNIaNsBfsvQYVbbpitikNRPxS5VyRyEda";
        };
        commit.gpgsign = true;
        tag.gpgSign = true;
        gpg = {
          format = "ssh";
          ssh.program = lib.getExe' pkgs.openssh "ssh-keygen";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      inputs'.comoji.packages.default # emoji conventional commits
      git-cliff # generate changelogs
      git-sizer
      git-subrepo
      git-filter-repo
      gitleaks
      # gitoxide # alternative git still wip
      onefetch # git summary
    ];
  };
}
