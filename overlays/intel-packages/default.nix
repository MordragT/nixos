self: pkgs: let
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
in rec {
  tbb = self.callPackage ./tbb.nix {
    inherit fetchDeb;
  };

  mpi = self.callPackage ./mpi.nix {
    inherit fetchDeb;
  };

  mkl = self.callPackage ./mkl.nix {
    inherit fetchDeb runtime mpi;
  };

  dpcpp-unwrapped = self.callPackage ./dpcpp.nix {
    inherit fetchDeb tbb;
  };
  runtime = dpcpp-unwrapped;

  dpcpp = self.callPackage ./wrap-dpcpp.nix {
    inherit dpcpp-unwrapped;
  };

  stdenv = pkgs.overrideCC pkgs.stdenv dpcpp;
}
