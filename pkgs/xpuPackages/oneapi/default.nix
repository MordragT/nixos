{
  pkgs,
  intel,
}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // intel);
in rec {
  oneapi-ccl = callPackage ./ccl.nix {};
  oneapi-dal = callPackage ./dal.nix {
    inherit oneapi-tbb;
  };
  oneapi-dpl = callPackage ./dpl.nix {
    inherit oneapi-tbb;
  };
  oneapi-dnn = pkgs.oneDNN;
  oneapi-mkl = callPackage ./mkl.nix {
    inherit oneapi-tbb;
  };
  oneapi-tbb = pkgs.tbb_2021_8;
  level-zero = pkgs.level-zero;
  unified-runtime = callPackage ./unified-runtime.nix {};
}
