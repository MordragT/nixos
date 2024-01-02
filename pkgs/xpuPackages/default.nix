{callPackage}: {
  dpcpp-cpp = callPackage ./dpcpp-cpp.nix {};
  oneDPL = callPackage ./oneDPL.nix {};
  oneMKL = callPackage ./oneMKL.nix {};
  oneURT = callPackage ./oneURT.nix {};
  stdenv = callPackage ./stdenv.nix {};
}
