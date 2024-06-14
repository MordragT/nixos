self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self // (pkgs.callPackage ./build-support.nix {}));
in {
  dpcppStdenv = self.intel-dpcpp.stdenv;

  intel-ccl = callPackage ./ccl.nix {};
  intel-dnnl = callPackage ./dnnl.nix {};
  intel-dpcpp = import ./dpcpp self.intel-dpcpp self;
  intel-llvm = import ./llvm self.intel-llvm pkgs;
  intel-mkl = callPackage ./mkl.nix {};
  intel-mpi = callPackage ./mpi.nix {};
  intel-tbb = callPackage ./tbb.nix {};
}
