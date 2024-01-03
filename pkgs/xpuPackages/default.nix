{pkgs}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = rec {
    # mkl = callPackage ./mkl.nix {};
    llvm = import ./llvm {inherit pkgs;};
    oneCCL = callPackage ./oneCCL.nix {};
    oneDAL = callPackage ./oneDAL.nix {};
    oneDPL = callPackage ./oneDPL.nix {};
    oneDNN = pkgs.oneDNN;
    oneMKL = callPackage ./oneMKL.nix {
      inherit (llvm) sycl stdenv;
    };
    oneTBB = pkgs.tbb_2021_8;
    unified-runtime = callPackage ./unified-runtime.nix {};
    level-zero = pkgs.level-zero;
  };
in
  self
