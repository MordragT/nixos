self: pkgs: let
  callPackage = self.callPackage;
in rec {
  llvm = callPackage ./llvm.nix {
    inherit callPackage;
  };
  sycl = llvm;

  compiler-rt = import ./compiler-rt.nix {
    inherit callPackage;
    stdenv = stdenvNoLibs;
  };

  pstl = import ./pstl.nix {
    inherit callPackage;
    stdenv = stdenvNoLibs;
  };

  openmp = import ./openmp.nix {
    inherit callPackage;
    stdenv = stdenvNoLibs;
  };

  libc = import ./libc.nix {
    inherit callPackage;
    stdenv = stdenvNoLibs;
  };

  libcxx = import ./libcxx.nix {
    inherit callPackage;
    stdenv = stdenvNoLibs;
  };

  clang = callPackage ./clang.nix {
    inherit llvm compiler-rt pstl libcxx;
    # not working inherit openmp libc;
  };
  # pkgs.buildEnv ?
  stdenv = pkgs.overrideCC pkgs.stdenv clang;
  stdenvNoLibs = pkgs.overrideCC pkgs.clangStdenvNoLibs (pkgs.wrapCC llvm);
}
