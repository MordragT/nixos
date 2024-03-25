self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self // (pkgs.callPackage ./build-support.nix {}));
in {
  tbb = callPackage ./tbb.nix {};
  mpi = callPackage ./mpi.nix {};
  mkl = callPackage ./mkl.nix {};

  dpcpp-unwrapped = callPackage ./dpcpp.nix {};
  dpcpp = callPackage ./wrap-dpcpp.nix {};
  env = pkgs.overrideCC pkgs.stdenv self.dpcpp;

  runtime = self.dpcpp-unwrapped;
}
