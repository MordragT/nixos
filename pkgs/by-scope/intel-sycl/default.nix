self: pkgs: let
  callPackage = pkgs.callPackage;
  pins = pkgs.callPackage ./pins {};
  # version = "6.2.0";
  # src = pkgs.fetchFromGitHub {
  #   owner = "intel";
  #   repo = "llvm";
  #   rev = "v${version}";
  #   hash = "sha256-j8+DmGKO0qDF5JjH+DlkLKs1kBz6dS7ukwySd/Crqv0=";
  # };
  version = "nightly-2025-11-04";
  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = version;
    hash = "sha256-a07jm+N1UuvUkLcd1C0BFqyG9JV0gRC2aJokvr/nA54=";
  };
in {
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
    inherit src version pins;
  };
}
