global: self:
let
  inherit (global) callPackage;
  pins = callPackage ./pins { };
  # version = "6.2.0";
  # src = pkgs.fetchFromGitHub {
  #   owner = "intel";
  #   repo = "llvm";
  #   rev = "v${version}";
  #   hash = "sha256-j8+DmGKO0qDF5JjH+DlkLKs1kBz6dS7ukwySd/Crqv0=";
  # };
  version = "nightly-2026-01-01";
  src = global.fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = version;
    hash = "sha256-OkSyn2KdAzptgKpTAnw//+6x8fbk/5Rjh1/6soQAjWc=";
  };
in
{
  lld = callPackage ./lld {
    inherit (self) llvm;
    inherit src version;
  };

  llvm-bin = callPackage ./llvm-bin {
    inherit version;
  };

  llvm = callPackage ./llvm {
    inherit src version pins;
  };

  bintools-unwrapped = callPackage ./bintools-unwrapped {
    inherit (self) llvm lld;
  };

  bintools = global.wrapBintoolsWith {
    bintools = self.bintools-unwrapped;
  };

  clang = callPackage ./clang {
    inherit (self) bintools llvm;
  };

  stdenv = global.overrideCC global.stdenv self.clang;

  dpcpp-compat = callPackage ./dpcpp-compat {
    inherit (self) clang llvm openmp;
  };

  compatStdenv = global.overrideCC global.stdenv self.dpcpp-compat;

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
    inherit src version pins;
  };
}
