{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Thomas Wehmöller";
    userEmail = "connect.mordrag@gmx.de";
  };
  home.packages = with pkgs; [ git-subrepo ];

}
