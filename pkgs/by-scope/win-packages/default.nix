self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self // (pkgs.callPackage ./build-support.nix {}));
in {
  # TODO broken compile wine-lol by source
  league-of-legends = callPackage ./league-of-legends.nix {};
  battle-net = callPackage ./battle-net.nix {};
  wine-ge-bin = callPackage ./wine-ge.nix {};
  wine-lol-bin = callPackage ./wine-lol.nix {};
}
