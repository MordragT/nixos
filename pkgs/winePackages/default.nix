{pkgs, ...}: rec {
  wine-ge-bin = pkgs.callPackage ./wine-ge.nix {};
  wine-lol-bin = pkgs.callPackage ./wine-lol.nix {};
  league-of-legends = pkgs.callPackage ./league-of-legends.nix {inherit wine-lol-bin;};
}
