{
  stdenv,
  callPackage,
}:
callPackage ./base.nix rec {
  inherit stdenv;

  name = "openmp";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
