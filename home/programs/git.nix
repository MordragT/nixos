{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Thomas Wehmöller";
    userEmail = "connect.mordrag@gmx.de";
  };
  home.packages = with pkgs; [
    comoji # emoji conventional commits
    git-cliff # generate changelogs
    git-subrepo
    # gitoxide # alternative git still wip
    onefetch # git summary
  ];
}
