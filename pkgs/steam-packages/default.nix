self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self // (pkgs.callPackage ./build-support.nix {}));
in {
  opengothic = callPackage ./opengothic.nix {};
  proton-cachyos-bin = callPackage ./proton-cachyos.nix {};
  proton-ge-bin = pkgs.proton-ge-bin;
  luxtorpeda = pkgs.luxtorpeda;
  steamtinkerlaunch = pkgs.steamtinkerlaunch;
}
