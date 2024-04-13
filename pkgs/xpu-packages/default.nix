self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  llvm = callPackage ./llvm.nix {
    inherit callPackage;
  };
  sycl = self.llvm;

  compiler-rt = callPackage ./compiler-rt.nix {
    inherit callPackage;
  };

  pstl = callPackage ./pstl.nix {
    inherit callPackage;
  };

  openmp = callPackage ./openmp.nix {
    inherit callPackage;
  };

  libc = callPackage ./libc.nix {
    inherit callPackage;
  };

  libcxx = callPackage ./libcxx.nix {
    inherit callPackage;
  };

  libdevice = callPackage ./libdevice.nix {
    inherit callPackage;
  };

  clang = callPackage ./clang.nix {};
  # pkgs.buildEnv ?
  env = pkgs.overrideCC pkgs.stdenv self.clang;
  envNoLibs = pkgs.overrideCC pkgs.clangStdenvNoLibs (pkgs.wrapCC self.llvm);
}
