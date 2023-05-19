{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice-fresh
    okular
    poppler_utils # utils for pdfs
  ];

}
