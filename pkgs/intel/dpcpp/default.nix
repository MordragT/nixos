self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self // (pkgs.callPackage ../build-support.nix {}));
in {
  bintools-unwrapped = callPackage ./bintools-unwrapped.nix {};
  bintools = pkgs.wrapBintoolsWith {
    bintools = self.bintools-unwrapped;
  };
  dpcpp-unwrapped = callPackage ./dpcpp.nix {
    inherit (pkgs) stdenv;
  };
  dpcpp = callPackage ./wrap-dpcpp.nix {
    inherit (self) bintools;
    inherit (pkgs) stdenv;
  };
  runtime = self.dpcpp-unwrapped;
  stdenv = pkgs.overrideCC pkgs.stdenv self.dpcpp;
}
