self: pkgs: let
  mkBottle = self.callPackage ./make-bottle.nix {};
in rec {
  league-of-legends = self.callPackage ./league-of-legends.nix {
    # TODO broken compile wine-lol by source
    inherit mkBottle wine-lol-bin;
  };
  battle-net = self.callPackage ./battle-net.nix {
    inherit mkBottle;
  };
  wine-ge-bin = self.callPackage ./wine-ge.nix {};
  wine-lol-bin = self.callPackage ./wine-lol.nix {};
}
