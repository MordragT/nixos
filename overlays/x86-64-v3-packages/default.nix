self: pkgs: let
  callPackage = self.callPackage;
in rec {
  stdenv = callPackage ./stdenv.nix {};
  opengothic = callPackage ./opengothic.nix {
    inherit stdenv;
  };
}
