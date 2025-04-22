self: pkgs: let
  callPackage = pkgs.callPackage;
  pins = pkgs.callPackage ./pins {};
  # wait for next proper release so that
  # I do not have to reverse changes to cmake variables
  # version = "6.0.1";
  version = "nightly-2025-04-05";
  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    # rev = "v${version}";
    rev = version;
    hash = "sha256-xW4OON6Zm6IibaN6L7b32nzbvG4K51YO3OnjFodBK5A=";
  };
in {
  llvm-bin = callPackage ./llvm-bin {
    inherit version;
  };

  llvm = self.llvm-bin;
  llvm-wip = callPackage ./llvm {
    inherit src version pins;
  };

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
    inherit src version pins;
  };
}
