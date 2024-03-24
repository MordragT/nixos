self: pkgs: let
  mkCompat = self.callPackage ./make-compat.nix {};
in {
  opengothic = self.callPackage ./opengothic.nix {
    inherit mkCompat;
  };
  proton-cachyos-bin = self.callPackage ./proton-cachyos.nix {};
  proton-ge-bin = pkgs.proton-ge-bin;
  luxtorpeda = pkgs.luxtorpeda;
  steamtinkerlaunch = pkgs.steamtinkerlaunch;
}
