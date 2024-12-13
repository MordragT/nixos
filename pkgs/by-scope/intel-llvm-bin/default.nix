self: pkgs: let
  callPackage = pkgs.callPackage;
in {
  llvm = callPackage ./llvm.nix {};

  bintools-unwrapped = callPackage ./bintools-unwrapped.nix {
    inherit (self) llvm;
  };

  bintools = pkgs.wrapBintoolsWith {
    bintools = self.bintools-unwrapped;
  };

  clang = callPackage ./clang.nix {
    inherit (self) bintools llvm;
  };

  stdenv = pkgs.overrideCC pkgs.stdenv self.clang;

  openmp = callPackage ./openmp.nix {
    inherit (self) stdenv;
  };
}
