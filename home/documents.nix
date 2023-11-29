{pkgs, ...}: {
  home.packages = with pkgs; [
    # libreoffice-fresh
    onlyoffice-bin_7_5
    #okular
    xournalpp
    poppler_utils # utils for pdfs
  ];
}
