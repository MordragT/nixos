{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Rust Tools
    gitoxide # alternative git still wip
    git-cliff # generate changelogs
    comoji # emoji conventional commits
    onefetch # git summary
    difftastic # a diff tool
    pijul # alternative vcs
    just # make alike
    hexyl # hex viewer
    lapce # code editor

    (dvc.override { enableAWS = true; }) # data version control
    awscli2 # amazon web services
    nodePackages.reveal-md # create presentations from markdown
    vagrant # vm provisioning

    nixpkgs-fmt # nix files are everywhere anyways
    android-studio
    jetbrains.idea-community
    dbeaver # sql client
    godot # game engine
    epic-asset-manager # manager for unreal engine and its assets
    akira-unstable # prototype gui
    gaphor # create diagrams and uml
    apostrophe # markdown editor
    renderdoc # debug graphics
    #oneapi # roofline, gpgpu etc.
    likwid # performance monitoring
    byfl # compiler based application analysis
    hollywood # fake hacking
  ];
}

