self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  env = callPackage ./env.nix {};
  opengothic = callPackage ./opengothic.nix {};
}
