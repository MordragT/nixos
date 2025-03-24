self: pkgs: let
  callPackage = pkgs.callPackage;
  pins = pkgs.callPackage ./pins {};
  version = "nightly-2025-03-24";
  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = version;
    hash = "";
  };
in {
  llvm-bin = callPackage ./llvm-bin {
    inherit version;
  };

  # llvm = callPackage ./llvm {
  #   inherit src version pins;
  # };
  llvm = self.llvm-bin;

  bintools-unwrapped = callPackage ./bintools-unwrapped {
    inherit (self) llvm;
  };

  bintools = pkgs.wrapBintoolsWith {
    bintools = self.bintools-unwrapped;
  };

  clang = callPackage ./clang {
    inherit (self) bintools llvm;
  };

  stdenv = pkgs.overrideCC pkgs.stdenv self.clang;

  openmp = callPackage ./openmp {
    inherit (self) stdenv;
    inherit src version;
  };

  xpti = callPackage ./xpti {
    inherit (self) stdenv;
    inherit src version;
  };

  xptifw = callPackage ./xptifw {
    inherit (self) stdenv;
    inherit src version;
  };
}
