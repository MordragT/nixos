{pkgs, ...}: {
  home.packages = with pkgs; [
    calls # phone dialer and call handler
    denaro # personal finance manager
    endeavour # task manager
    planify # more advanced task manager
    foliate # book reader
    rnote # draw notes
    paperwork
    pdfarranger
  ];
}
