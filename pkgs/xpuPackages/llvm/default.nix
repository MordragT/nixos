{pkgs}: let
  callPackage = pkgs.callPackage;
  version = "nightly-2024-01-24";
  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = version;
    hash = "sha256-ObN7Pp1rvz6s6NMn6HTvCPoG7QYCT83sbJPIssnoby4=";
  };
in rec {
  llvm = callPackage ./llvm.nix {inherit src version;};
  sycl = llvm;
  # pkgs.buildEnv ?
  stdenv = pkgs.overrideCC pkgs.stdenv clang;
  clang = pkgs.wrapCCWith {
    inherit libcxx;
    # inherit libc;
    libc = pkgs.glibc;
    cc = llvm;
    bintools = pkgs.wrapBintoolsWith {
      libc = pkgs.glibc;
      bintools = llvm;
    };
    extraPackages = [
      compiler-rt
      pstl
      # openmp
    ];
  };
  compiler-rt = callPackage ./runtime.nix {
    inherit llvm src version;
    runtime = "compiler-rt";
  };
  pstl = callPackage ./runtime.nix {
    inherit llvm src version;
    runtime = "pstl";
  };
  # not working
  # openmp = callPackage ./runtime.nix {
  #   inherit llvm src version;
  #   runtime = "openmp";
  # };
  # not working
  # libc = callPackage ./runtime.nix {
  #   inherit llvm src version;
  #   runtime = "libc";
  # };
  libcxx = callPackage ./runtime.nix {
    inherit llvm src version;
    pname = "libcxx";
    runtime = "libcxx;libcxxabi;libunwind;";
  };
}
