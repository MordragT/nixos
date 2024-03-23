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
  llvm-bin = callPackage ./llvm-bin.nix {};
  sycl = llvm;
  stdenv = pkgs.overrideCC pkgs.llvmPackages.libcxxStdenv clang;
  clang = pkgs.wrapCCWith {
    inherit (pkgs.llvmPackages) bintools;
    inherit libcxx;
    cc = llvm;
    # inherit libc;
    # bintools = pkgs.wrapBintoolsWith {
    #   inherit libc;
    #   bintools = llvm;
    # };
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
  dpcpp-unwrapped = callPackage ./dpcpp.nix {inherit oneTBB;};
  dpcpp = pkgs.wrapCC dpcpp-unwrapped;
  dpcenv = pkgs.overrideCC pkgs.llvmPackages_16.stdenv dpcpp;
  # mkl = callPackage ./mkl.nix {};
  oneCCL = callPackage ./oneCCL.nix {};
  oneDAL = callPackage ./oneDAL.nix {};
  oneDPL = callPackage ./oneDPL.nix {};
  oneDNN = pkgs.oneDNN;
  oneMKL = callPackage ./oneMKL.nix {
    inherit dpcenv oneTBB;
  };
  oneTBB = pkgs.tbb_2021_8;
  level-zero = pkgs.level-zero;
  unified-runtime = callPackage ./unified-runtime.nix {};
}
