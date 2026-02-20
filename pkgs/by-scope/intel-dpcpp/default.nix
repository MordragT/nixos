self: pkgs:
let
  inherit (pkgs) callPackage;
in
{
  llvm = callPackage ./llvm.nix { };

  bintools-unwrapped = callPackage ./bintools-unwrapped.nix {
    inherit (self) llvm;
  };

  bintools = pkgs.wrapBintoolsWith {
    bintools = self.bintools-unwrapped;
  };

  clang = callPackage ./clang.nix {
    inherit (self) bintools compiler-tools llvm;
  };

  compiler-tools = callPackage ./compiler-tools.nix {
    inherit (self) llvm;
  };

  stdenv = pkgs.overrideCC pkgs.stdenv self.clang;
}
