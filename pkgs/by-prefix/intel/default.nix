self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self // (pkgs.callPackage ./build-support.nix {}));
in {
  dpcppStdenv = self.intel-dpcpp.stdenv;
  invokeai = with self.intel-python.pkgs; toPythonApplication invokeai;

  intel-ccl = callPackage ./ccl.nix {};
  intel-dnnl = callPackage ./dnnl.nix {};
  intel-dpcpp = import ./dpcpp self.intel-dpcpp self;
  intel-llvm = import ./llvm self.intel-llvm pkgs;
  intel-mkl = callPackage ./mkl.nix {};
  intel-mpi = callPackage ./mpi.nix {};
  intel-python = pkgs.python3.override {
    packageOverrides = pySelf: pyPkgs:
      (import ./python pySelf pyPkgs)
      // {
        # https://github.com/NixOS/nixpkgs/pull/317546
        opencv4 = pySelf.toPythonModule (self.my-opencv.override {
          enablePython = true;
          pythonPackages = pySelf;
        });
      };
  };
  intel-tbb = callPackage ./tbb.nix {};
}
