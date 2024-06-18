self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  oneapi-ccl = callPackage ./ccl.nix {};
  oneapi-dal = callPackage ./dal.nix {};
  oneapi-dpl = callPackage ./dpl.nix {};
  oneapi-dnn = pkgs.oneDNN;
  oneapi-mkl = callPackage ./mkl.nix {};
  oneapi-tbb = pkgs.tbb_2021_8;
  unified-runtime = callPackage ./unified-runtime.nix {};
  unified-memory-framework = callPackage ./unified-memory-framework.nix {};
}
