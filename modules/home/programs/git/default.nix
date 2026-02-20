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
    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
        enableJujutsuIntegration = true;
      };

      git = {
        enable = true;
        ignores = [
          ".direnv"
        ];
        lfs.enable = true;
        settings = {
          alias = {
            ci = "commit -m";
            co = "checkout";
            l = "log --oneline";
            ll = "log";
            s = "status";
          };
          core = {
            editor = "hx";
          };
          init = {
            defaultBranch = "main";
          };
          user = {
            email = "connect.mordrag@gmx.de";
            name = "Thomas Wehmöller";
          };
        };
        signing = {
          format = "ssh";
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN40eH/59LSYNIaNsBfsvQYVbbpitikNRPxS5VyRyEda";
          signByDefault = true;
        };
      };

      jujutsu.enable = true;
    };

    home.packages = with pkgs; [
      comoji # emoji conventional commits
      git-cliff # generate changelogs
      git-sizer
      git-subrepo
      git-filter-repo
      gitbutler
      gitleaks
      # gitoxide # alternative git still wip
      onefetch # git summary
    ];
  };
}
