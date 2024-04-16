self: pkgs: let
  buildSupport = pkgs.callPackage ./build-support.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // self // buildSupport);
  overrideCC = pkgs.overrideCC;
in {
  ##########
  # Stage 0
  ##########

  # broken https://github.com/intel/llvm/issues/13396
  # therefore llvm includes both llvm and clang
  # clang-unwrapped = callPackage ./clang-unwrapped.nix {
  #   inherit (pkgs) stdenv;
  # };

  llvm = callPackage ./llvm.nix {
    inherit (pkgs) stdenv;
  };

  clangNoCompilerRt = pkgs.wrapCC self.llvm;

  ##########
  # Stage 1
  ##########

  compiler-rt = callPackage ./compiler-rt.nix {
    stdenv = overrideCC pkgs.stdenv self.clangNoCompilerRt;
  };

  lld = callPackage ./lld.nix {
    stdenv = overrideCC pkgs.stdenv self.clangNoCompilerRt;
  };

  bintools-unwrapped = callPackage ./bintools-unwrapped.nix {};
  clangNoLibcxx = callPackage ./clang-no-libcxx.nix {};

  ##########
  # Stage 2
  ##########

  # libc = callPackage ./libc.nix {
  #   stdenv = overrideCC pkgs.stdenv self.clangNoLibcxx;
  # };

  libcxx = callPackage ./libcxx.nix {
    stdenv = overrideCC pkgs.stdenv self.clangNoLibcxx;
  };

  clangLibcxx = callPackage ./clang-libcxx.nix {};

  ##########
  # Stage 3
  ##########

  llvm-spirv = callPackage ./llvm-spirv.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  openmp = callPackage ./openmp.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  pstl = callPackage ./pstl.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  sycl = callPackage ./sycl.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  xpti = callPackage ./xpti.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  xptifw = callPackage ./xptifw.nix {
    stdenv = overrideCC pkgs.stdenv self.clangLibcxx;
  };

  clang = callPackage ./clang.nix {};

  stdenv = overrideCC pkgs.stdenv self.clang;
}
