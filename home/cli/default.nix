{pkgs, ...}: {
  imports = [
    ./analysis.nix
    ./dev.nix
    ./media.nix
    # ./security.nix
  ];

  home.packages = with pkgs; [
    p7zip
    ollama # run large language models locally
    # nodePackages.reveal-md # create presentations from markdown
    # poppler_utils # utils for pdfs
  ];
}
