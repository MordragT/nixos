global: self:
let
  inherit (global) callPackage;
in
{
  llvm = global.callPackage ./llvm.nix { };

  bintools-unwrapped = callPackage ./bintools-unwrapped.nix {
    inherit (self) llvm;
  };

  bintools = global.wrapBintoolsWith {
    bintools = self.bintools-unwrapped;
  };

  clang = callPackage ./clang.nix {
    inherit (self) bintools compiler-tools llvm;
  };

  compiler-tools = callPackage ./compiler-tools.nix {
    inherit (self) llvm;
  };

  stdenv = global.overrideCC global.stdenv self.clang;
}
