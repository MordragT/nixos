self: pkgs: let
  callPackage = self.callPackage;
in rec {
  ccl = callPackage ./ccl.nix {};
  dal = callPackage ./dal.nix {
    inherit tbb;
  };
  dpl = callPackage ./dpl.nix {
    inherit tbb;
  };
  dnn = pkgs.oneDNN;
  mkl = callPackage ./mkl.nix {
    inherit tbb;
  };
  tbb = pkgs.tbb_2021_8;
  level-zero = pkgs.level-zero;
  unified-runtime = callPackage ./unified-runtime.nix {};
}
