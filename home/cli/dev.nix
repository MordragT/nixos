{pkgs, ...}: {
  home.packages = with pkgs; [
    # difftastic # a diff tool
    just # make alike
    # hexyl # hex viewer
    hollywood # fake hacking
    fzf # fuzzy file finder TODO if used copy to system

    # Version Control
    # pijul # alternative vcs
    # awscli2 # amazon web services
    # (dvc.override {enableAWS = true;}) # data version control
    dud # dvc alternative with rclone backend written in go

    rclone # sync data with cloud

    xpuPackages.ipex
    # python3Packages.xpu.ipex
  ];
}
