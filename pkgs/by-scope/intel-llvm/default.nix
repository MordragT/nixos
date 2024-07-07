self: pkgs: let
  buildSupport = pkgs.callPackage ./build-support.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // self // buildSupport);
  overrideCC = pkgs.overrideCC;
in {
  ##########
  # Stage 0
  ##########

  llvm = callPackage ./stage-0/llvm.nix {
    inherit (pkgs) stdenv;
  };

  # broken https://github.com/intel/llvm/issues/13396
  # therefore llvm includes both llvm and clang
  clang-unwrapped = callPackage ./stage-0/clang-unwrapped.nix {
    inherit (pkgs) stdenv;
  };

  clangNoCompilerRt = pkgs.wrapCC self.llvm;

  ##########
  # Stage 1
  ##########

  compiler-rt = callPackage ./stage-1/compiler-rt.nix {
    stdenv = overrideCC pkgs.stdenv self.clangNoCompilerRt;
  };

  lld = callPackage ./stage-1/lld.nix {
    stdenv = overrideCC pkgs.stdenv self.clangNoCompilerRt;
  };

  bintools-unwrapped = callPackage ./stage-1/bintools-unwrapped.nix {};
  clangNoLibcxx = callPackage ./stage-1/clang-no-libcxx.nix {};

  ##########
  # Stage 2
  ##########

  # libc = callPackage ./libc.nix {
  #   stdenv = overrideCC pkgs.stdenv self.clangNoLibcxx;
  # };

  libcxx = callPackage ./stage-2/libcxx.nix {
    stdenv = overrideCC pkgs.stdenv self.clangNoLibcxx;
  };

  clangLibcxx = callPackage ./stage-2/clang-libcxx.nix {};

  ##########
  # Stage 3
  ##########

  llvm-spirv = callPackage ./stage-3/llvm-spirv.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  openmp = callPackage ./stage-3/openmp.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  pstl = callPackage ./stage-3/pstl.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  sycl = callPackage ./stage-3/sycl.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  xpti = callPackage ./stage-3/xpti.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  xptifw = callPackage ./stage-3/xptifw.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  clang = callPackage ./stage-3/clang.nix {};

  stdenv = overrideCC pkgs.stdenv self.clang;
}
