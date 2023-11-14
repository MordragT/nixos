{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-fresh
    onlyoffice-bin_7_4
    #okular
    xournalpp
    poppler_utils # utils for pdfs
  ];
}
