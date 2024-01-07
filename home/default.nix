{pkgs, ...}: {
  imports = [
    ./cli
    ./gnome
    ./programs
    ./free.nix
    ./gaming.nix
    ./nix.nix
    ./unfree.nix
  ];
}
