self: pkgs: let
  mkBottle = self.callPackage ./make-bottle.nix {};
in rec {
  league-of-legends = self.callPackage ./league-of-legends.nix {
    inherit mkBottle;
    # TODO broken compile wine-lol by source
    wine = wine-lol-bin;
  };
  battle-net = import ./battle-net.nix {
    inherit mkBottle;
    wine = pkgs.wine-wayland;
  };
  wine-ge-bin = self.callPackage ./wine-ge.nix {};
  wine-lol-bin = self.callPackage ./wine-lol.nix {};
}
