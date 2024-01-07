{pkgs, ...}: {
  home.packages = with pkgs; [
    # difftastic # a diff tool
    just # make alike
    # hexyl # hex viewer
    hollywood # fake hacking

    # Version Control
    # pijul # alternative vcs
    # awscli2 # amazon web services
    # (dvc.override {enableAWS = true;}) # data version control
  ];
}
