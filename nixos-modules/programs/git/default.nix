{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
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
          signingKey = "2E3F 41E4 5C52 63BC 6A4A  5389 922C 9B26 1449 E566";
        };
        commit.gpgsign = true;
        tag.gpgSign = true;
        gpg.format = "openpgp";
        # When signingKey is an ssh key do this:
        # gpg = {
        #   format = "ssh";
        #   ssh.program = lib.getExe' pkgs.openssh "ssh-keygen";
        # };
      };
    };

    environment.systemPackages = with pkgs; [
      inputs.comoji.packages.${system}.default # emoji conventional commits
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
