{ pkgs }:
with pkgs; [
  # Rust Tools
  gitoxide # alternative git still wip
  git-cliff # generate changelogs
  comoji # emoji conventional commits
  onefetch # git summary
  difftastic # a diff tool
  pijul # alternative vcs
  just # make alike
  hexyl # hex viewer

  (dvc.override { enableAWS = true; }) # data version control
  awscli2 # amazon web services
  nodePackages.reveal-md # create presentations from markdown

  nixpkgs-fmt # nix files are everywhere anyways

  lapce # code editor
  dbeaver # sql client
  godot # game engine
  akira-unstable # prototype gui
  gaphor # create diagrams and uml
  apostrophe # markdown editor
  renderdoc # debug graphics
  #oneapi # roofline, gpgpu etc.
  likwid # performance monitoring
]
