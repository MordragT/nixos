{pkgs}: let
  # https://apt.repos.intel.com/oneapi/dists/all/main/binary-amd64/Packages
  # https://apt.repos.intel.com/oneapi/dists/all/main/binary-all/Packages
  fetchDeb = {
    package,
    hash,
  }:
    pkgs.fetchurl {
      inherit hash;
      url = "https://apt.repos.intel.com/oneapi/pool/main/${package}.deb";
    };
  callPackage = pkgs.lib.callPackageWith (pkgs // {inherit fetchDeb;});
in rec {
  intel-tbb = callPackage ./tbb.nix {};
  intel-mpi = callPackage ./mpi.nix {};
  intel-mkl = callPackage ./mkl.nix {
    inherit intel-runtime intel-mpi;
  };
  intel-dpcpp-unwrapped = callPackage ./dpcpp.nix {
    inherit intel-tbb;
  };
  intel-runtime = intel-dpcpp-unwrapped;
  intel-dpcpp = callPackage ./wrap-dpcpp.nix {
    inherit intel-dpcpp-unwrapped;
  };
  intel-env = pkgs.overrideCC pkgs.stdenv intel-dpcpp;
}
