self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  ccl = callPackage ./ccl.nix {};
  dal = callPackage ./dal.nix {};
  dpl = callPackage ./dpl.nix {};
  dnn = pkgs.oneDNN;
  mkl = callPackage ./mkl.nix {};
  tbb = pkgs.tbb_2021_8;
  level-zero = pkgs.level-zero;
  unified-runtime = callPackage ./unified-runtime.nix {};
  unified-memory-framework = callPackage ./unified-memory-framework.nix {};
}
